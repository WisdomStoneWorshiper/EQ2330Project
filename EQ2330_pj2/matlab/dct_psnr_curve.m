% 2.3-2 rate-PSNR curve
clc;
clear;
img_b = double(imread('../images/boats512x512.tif'));
img_h = double(imread('../images/harbour512x512.tif'));
img_p = double(imread('../images/peppers512x512.tif'));
bitrate = zeros(1, 10);
psnr = zeros(1, 10);
M = 8;

for i = 1:10
    mse(1) = get_mse(img_b, 2^(i-1), M);
    mse(2) = get_mse(img_h, 2^(i-1), M);
    mse(3) = get_mse(img_p, 2^(i-1), M);
    d = mean(mse);
    psnr(i) = 10*log10(255^2/d);
    [bitrates(1),entropy_1] = get_bitrate(img_b,2^(i-1),M);
    [bitrates(2),entropy_2] = get_bitrate(img_h,2^(i-1),M);
    [bitrates(3),entropy_3] = get_bitrate(img_p,2^(i-1),M);
    
    if (i == 7)
        entropy = (entropy_1+entropy_2+entropy_3)/3;
        figure;
        surf(entropy);
        title('Average entropy of the DCT coefficients');
    end
    bitrate(i) = mean(bitrates);
end