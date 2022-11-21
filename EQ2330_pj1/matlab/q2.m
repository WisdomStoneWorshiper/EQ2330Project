%%%2.2-1
lena_o = imread('lena512.bmp');
g_noise = mynoisegen('gaussian', 512, 512, 0, 64);
g_lena = g_noise+double(lena_o); % lena with gaussian noise
saltp_lena = lena_o; %lena with saltpepper noise
saltp_n = mynoisegen('saltpepper', 512, 512, .05, .05);
saltp_lena(saltp_n==0) = 0;
saltp_lena(saltp_n==1) = 255;

hist_o = histogram(double_lena_o);
hist_g = histogram(g_lena);
hist_saltp = histogram(double(saltp_lena));

%%%2.2-2
mean_filter = [1/9 1/9 1/9; 1/9 1/9 1/9; 1/9 1/9 1/9];
mean_g = conv2(mean_filter,g_lena);
mean_saltp = conv2(mean_filter, saltp_lena);
hist_mean_g = histogram(mean_g);
hist_mean_saltp = histogram(mean_saltp);

%%%2.2-3
%J = medfilt2(I)
median_g = medfilt2(g_lena);
median_saltp = medfilt2(saltp_lena);
hist_med_g = histogram(median_g);
hist_med_saltp = histogram(median_saltp);