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
y = Mydct2(boat8x8,M);

%inverse dct2 transfosrm
subplot(1,3,3);
Myindct2(y,M);
