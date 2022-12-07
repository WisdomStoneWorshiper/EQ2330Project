clc;
clear;

load coeffs.mat

img = imread("../images/harbour512x512.tif");

scale = 4;

[LLs, LHs, HLs, HHs] = fwt2d_scale(img, scale);

figure(1);
subplot(1, 4, 1);
imagesc(LLs{scale});
title("approximation coefficients");
subplot(1, 4, 2);
imagesc(LHs{scale});
title("horizontal coefficients");
subplot(1, 4, 3);
imagesc(HLs{scale});
title("vertical coefficients");
subplot(1, 4, 4);
imagesc(HHs{scale});
title("diagonal coefficients");
colormap gray(256);

step = 1;

[qLLs, qLHs, qHLs, qHHs] = quantize_all(LLs, LHs, HLs, HHs, scale, step);
img_re = ifwt2d_scale(qLLs, qLHs, qHLs, qHHs, scale);

figure(2);
subplot(1, 2, 1);
imagesc(img);
title("original");
subplot(1, 2, 2);
imagesc(img_re);
title("reconstructed");
colormap gray(256);

img = 255*im2double(img);

ori_re_mse = mse(img, img_re);

disp("d between original and reconstructed: " + ori_re_mse);

LLs_mse = zeros(1,4);
LHs_mse = zeros(1,4);
HLs_mse = zeros(1,4);
HHs_mse = zeros(1,4);

for i = 1:scale
    LLs_mse(i) = mse(LLs{i},qLLs{i});
    LHs_mse(i) = mse(LHs{i},qLHs{i});
    HLs_mse(i) = mse(HLs{i},qHLs{i});
    HHs_mse(i) = mse(HHs{i},qHHs{i});
end

overall_cof_mean = 0;

for i = 1:scale
    overall_cof_mean = overall_cof_mean + LHs_mse(i)*(1/(4^i));
    overall_cof_mean = overall_cof_mean + HLs_mse(i)*(1/(4^i));
    overall_cof_mean = overall_cof_mean + HHs_mse(i)*(1/(4^i));
end

overall_cof_mean = overall_cof_mean + LLs_mse(scale)*(1/(4^scale));
