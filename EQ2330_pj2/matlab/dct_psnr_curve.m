% 2.3-2
% rate-PSNR curve

clc;
clear;
img_b = double(imread('../images/boats512x512.tif'));
img_h = double(imread('../images/harbour512x512.tif'));
img_p = double(imread('../images/peppers512x512.tif'));
M = 8;
step_len = 1:10;
bitrate = zeros(1, 10);
psnr = zeros(1, 10);

for i = step_len
    step = 2^(i-1);
    mse(1) = mymse(img_b, step, M);
    mse(2) = mymse(img_h, step, M);
    mse(3) = mymse(img_p, step, M);
    d = mean(mse);
    psnr(i) = 10*log10(255^2/d);
    [bitrates(1),entropy1] = mybitrate(img_b,step,M);
    [bitrates(2),entropy2] = mybitrate(img_h,step,M);
    [bitrates(3),entropy3] = mybitrate(img_p,step,M);
    
    if (i == 7)
        entropy = (entropy1+entropy2+entropy3)/3;
        figure;
        surf(entropy);
        title('Average entropy of DCT coefficients');
    end
    bitrate(i) = mean(bitrates);
end