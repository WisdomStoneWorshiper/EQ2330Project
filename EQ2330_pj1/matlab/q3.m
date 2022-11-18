f = imread("../images/lena512.bmp");

r = 8; % from the instruction
h = myblurgen('gaussian', r);
g = conv2(f, h, 'same');
[x_max, y_max] = size(g);

for i = 1:x_max

    for j = 1:y_max
        g(i, j) = min([max([g(i, j), 0]), 255]);
    end

end

f = im2double(f);
g = im2double(g);

F = fft2(f);
F = fftshift(F);
F_spectra = log(abs(F));

G = fft2(g);
G = fftshift(G);
G_spectra = log(abs(G));
% g = imread("../images/boats512_outoffocus.bmp");
% g = im2double(g);
f_hat = wiener_filter(g, h, 0.0833);

% imagesc((F_spectra));
% colormap gray(256);
% figure, imagesc(G_spectra);
% colormap gray(256);
% % figure, imagesc(f);
% % colormap gray(256);
% figure, imagesc(g);
% colormap gray(256);
% figure, imagesc(f_hat);
% colormap gray(256);

figure(4);
subplot(2,2,1);
imagesc((F_spectra));
subplot(2,2,2);
imagesc(G_spectra);
subplot(2,2,3);
imagesc(g);
subplot(2,2,4);
imagesc(f_hat);
colormap gray(256);
