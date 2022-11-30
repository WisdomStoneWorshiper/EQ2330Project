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
LLs{scale} = quantizer(LLs{scale}, step);
LHs{scale} = quantizer(LHs{scale}, step);
HLs{scale} = quantizer(HLs{scale}, step);
HHs{scale} = quantizer(HHs{scale}, step);
