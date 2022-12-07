function [weigthed_avg_bitrates, avg_PSNRs] = fwt_psnr_bitrate()

imgs{1} = 255*im2double(imread("../images/boats512x512.tif"));
imgs{2} = 255*im2double(imread("../images/harbour512x512.tif"));
imgs{3} = 255*im2double(imread("../images/peppers512x512.tif"));

[~, total_imgs] = size(imgs);

scale = 4;

step_range = [2^0, 2^1, 2^2, 2^3, 2^4, 2^5, 2^6, 2^7, 2^8, 2^9];

[~, total_step_range] = size(step_range);

bitrates = zeros(10,4,scale);
weigthed_avg_bitrates = zeros(10,1);

PSNRs = zeros(10, 3);

for i = 1:total_step_range
    concated_coffs = cell(4,scale);
    for j = 1:total_imgs
        [LLs, LHs, HLs, HHs] = fwt2d_scale(imgs{j}, scale);
        [LLs, LHs, HLs, HHs] = quantize_all(LLs, LHs, HLs, HHs, scale, step_range(i));
        
        img_re = ifwt2d_scale(LLs, LHs, HLs, HHs, scale);
        PSNRs(i,j) = psnr_8bits(imgs{j}, img_re);
        
        if j == 1
            for k = 1:scale
                concated_coffs{1,k} = LLs{k}(:);
                concated_coffs{2,k} = LHs{k}(:);
                concated_coffs{3,k} = HLs{k}(:);
                concated_coffs{4,k} = HHs{k}(:);
            end
            
        else
            for k = 1:scale
                concated_coffs{1,k} = [concated_coffs{1,k};LLs{k}(:)];
                concated_coffs{2,k} = [concated_coffs{2,k};LHs{k}(:)];
                concated_coffs{3,k} = [concated_coffs{3,k};HLs{k}(:)];
                concated_coffs{4,k} = [concated_coffs{4,k};HHs{k}(:)];
            end
        end
     
    end
    for j = 1:4
        for k = 1: scale
            bitrates(i,j,k)= bitrate(concated_coffs{j,k});
        end
    end
    for j = 2:4
        for k = 1:scale
            weigthed_avg_bitrates(i) = weigthed_avg_bitrates(i) + bitrates(i,j,k)*1/(4^k);
        end
    end
    weigthed_avg_bitrates(i) = weigthed_avg_bitrates(i) + bitrates(i,1,scale) * 1/(4^k);

end

avg_PSNRs = mean(PSNRs, 2).';

% figure(3);
% plot(weigthed_avg_bitrates, avg_PSNRs, '-ro');
% xlabel("Bit-rates");
% ylabel("PSNR");
end

