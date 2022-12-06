clc;
clear;

imgs{1} = 255*im2double(imread("../images/boats512x512.tif"));
imgs{2} = 255*im2double(imread("../images/harbour512x512.tif"));
imgs{3} = 255*im2double(imread("../images/peppers512x512.tif"));

[~, total_imgs] = size(imgs);

scale = 1;

step_range = [2^0, 2^1, 2^2, 2^3, 2^4, 2^5, 2^6, 2^7, 2^8, 2^9];

[~, total_step_range] = size(step_range);
bitrates = zeros(4, 10, 3);
PSNRs = zeros(10, 3);

for i = 1:total_step_range
    for j = 1:total_imgs
        [LLs, LHs, HLs, HHs] = fwt2d_scale(imgs{j}, scale);
        [LLs, LHs, HLs, HHs] = quantize_all(LLs, LHs, HLs, HHs, scale, step_range(i));
        
        
        bitrates(1,i,j) = bitrate(LLs{1});
        bitrates(2,i,j) = bitrate(LHs{1});
        bitrates(3,i,j) = bitrate(HLs{1});
        bitrates(4,i,j) = bitrate(HHs{1});
        img_re = ifwt2d_scale(LLs, LHs, HLs, HHs, scale);
        PSNRs(i,j) = psnr_8bits(imgs{j}, img_re);
    end
end

avg_cof_bitrate = mean(bitrates,1);

avg_bitrate = mean(avg_cof_bitrate, 3);

avg_PSNR = mean(PSNRs, 2).';

figure(3);
plot(avg_bitrate, avg_PSNR, '-ro');
xlabel("Bit-rates");
ylabel("PSNR");


