%%%2.2-1
lena_o = imread('lena512.bmp');
g_noise = mynoisegen('gaussian', 512, 512, 0, 64);
g_lena = g_noise+double(lena_o); % lena with gaussian noise
saltp_lena = lena_o; %lena with saltpepper noise
saltp_n = mynoisegen('saltpepper', 512, 512, .05, .05);
saltp_lena(saltp_n==0) = 0;
saltp_lena(saltp_n==1) = 255;

%hist_o = histogram(double_lena_o);
%hist_g = histogram(g_lena);
%hist_saltp = histogram(double(saltp_lena));

%%%2.2-2
mean_filter = [1/9 1/9 1/9; 1/9 1/9 1/9; 1/9 1/9 1/9];
mean_g = conv2(mean_filter,g_lena);
mean_saltp = conv2(mean_filter, saltp_lena);
%hist_mean_g = histogram(mean_g);
%hist_mean_saltp = histogram(mean_saltp);

%%%2.2-3
%J = medfilt2(I)
median_g = medfilt2(g_lena);
median_saltp = medfilt2(saltp_lena);
%hist_med_g = histogram(median_g);
%hist_med_saltp = histogram(median_saltp);

% Display histogram
figure(1);
subplot(2,3,1);
histogram(g_lena);
xlabel('r');
ylabel('h(r)');
title('gaussian noise image');
axis([0 255 0 inf]);
subplot(2,3,2);
histogram(mean_g);
xlabel('r');
ylabel('h(r)');
title('gaussian noise image after mean filter');
axis([0 255 0 inf]);
subplot(2,3,3);
histogram(median_g);
xlabel('r');
ylabel('h(r)');
title('gaussian noise image after median filter');
axis([0 255 0 inf]);
subplot(2,3,4);
histogram(double(saltp_lena));
xlabel('r');
ylabel('h(r)');
title('salt&pepper noise image');
axis([0 255 0 inf]);
subplot(2,3,5);
histogram(mean_saltp);
xlabel('r');
ylabel('h(r)');
title('salt&pepper noise image after mean filter');
axis([0 255 0 inf]);
subplot(2,3,6);
histogram(median_saltp);
xlabel('r');
ylabel('h(r)');
title('salt&pepper noise image after median filter');
axis([0 255 0 inf]);

% Display the 'Lena' image
figure(2);
subplot(2,3,1);
imagesc(g_lena,[0 255]);
title('gaussian noise image');
subplot(2,3,2);
imagesc(mean_g,[0 255]);
title('gaussian noise image after mean filter');
subplot(2,3,3);
imagesc(median_g,[0 255]);
title('gaussian noise image after median filter');
subplot(2,3,4);
imagesc(saltp_lena,[0 255]);
title('salt&pepper noise image');
subplot(2,3,5);
imagesc(mean_saltp,[0 255]);
title('salt&pepper noise image after mean filter');
subplot(2,3,6);
imagesc(median_saltp,[0 255]);
title('salt&pepper noise image after median filter');
colormap gray(256);