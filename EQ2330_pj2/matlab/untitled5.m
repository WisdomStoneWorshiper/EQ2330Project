% assignment 2.1&2.2
clc;
clear;

I = double(imread('../images/boats512x512.tif'));
m = 50;
M = 8;

[D,A] = mydct2(I,M); % DCT
subplot(1,3,2);
plot_matrix(D);
title('DCT');

Dinv = A'*D*A; % inverse DCT 
subplot(1,3,3);
plot_matrix(Dinv);
title('IDCT');