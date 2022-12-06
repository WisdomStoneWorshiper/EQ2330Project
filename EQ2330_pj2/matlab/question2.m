%import photos
boat = imread("../images/boats512x512.tif");
harbours = imread("../images/harbour512x512.tif");
peppers = imread("../images/peppers512x512.tif");


%DCT of block size 8x8
M = 8;
A = dct2matrixA(M); % matrix A in dct2
disp(A);
%use boat 8x8 to test the function
boat8x8 = imresize(boat,[8 8]);
boat8x8 = double(boat8x8);
figure(3)
subplot(1,3,1);
imagesc(boat8x8);

%dct2 transform 
subplot(1,3,2);
y = get_dct2(boat8x8,M);

%inverse dct2 transfosrm
subplot(1,3,3);
get_indct2(y,M);

plot_matrix(x);

% quantizer
% x: 0-64
% y: function output
figure(1);
arr = 0:0.1:64;
output = quantizer(arr, 4);
subplot(1,1,1);
plot(arr, output);
