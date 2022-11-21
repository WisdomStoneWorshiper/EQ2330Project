f = imread("../images/lena512.bmp"); % load an image

r = 8; % Gaussian kernel radius from the instruction
h = myblurgen('gaussian', r); % use gaussian blur to blur the image
g = conv2(f, h, 'same'); % make sure the output image size is same as the input image size
[M, N] = size(g);

% apply the quantization noise
for i = 1:M

    for j = 1:N
        g(i, j) = min([max([g(i, j), 0]), 255]);
    end

end

f = im2double(f);
g = im2double(g);

F = fft2(f);
F = fftshift(F); % center the spectra
F_spectra = log(abs(F)); % take the log value for visualization purpose

G = fft2(g);
G = fftshift(G);
G_spectra = log(abs(G));

% read a blurred image
g_blur = imread("../images/boats512_outoffocus.bmp");
g_blur = im2double(g_blur);
var = 0.0833; % noise variance from the instruction
f_hat = wiener_filter(g_blur, h, var);

% show the result
figure(4);
subplot(2, 2, 1);
imagesc((F_spectra));
subplot(2, 2, 2);
imagesc(G_spectra);
subplot(2, 2, 3);
imagesc(g_blur);
subplot(2, 2, 4);
imagesc(f_hat);
colormap gray(256);
