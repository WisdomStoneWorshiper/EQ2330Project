load coeffs.mat

img = imread("../images/harbour512x512.tif");

scale = 4;

[LLs, LHs, HLs, HHs] = fwt2d_scale(img, scale);

subplot(2, 2, 1);
imagesc(LLs{scale});
subplot(2, 2, 2);
imagesc(LHs{scale});
subplot(2, 2, 3);
imagesc(HLs{scale});
subplot(2, 2, 4);
imagesc(HHs{scale});
colormap gray(256);

step = 1;

[LLs, LHs, HLs, HHs] = quantize_all(LLs, LHs, HLs, HHs, scale, step);
img_re = ifwt2d_scale(LLs, LHs, HLs, HHs, scale);

subplot(1, 2, 1);
imagesc(img);
subplot(1, 2, 2);
imagesc(img_re);
colormap gray(256);

img = im2double(img);

harbour_psnr = psnr_8bits(img, img_re);
b = bitrate(LLs{1});

disp("harbour_psnr: " + harbour_psnr);
