%import photos
boat = double(imread("../images/boats512x512.tif"));
harbours = double(imread("../images/harbour512x512.tif"));
peppers = double(imread("../images/peppers512x512.tif"));


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

% quantizer
% x: 0-64
% y: function output
figure(1);
arr = 0:0.1:64;
output = quantizer(arr, 4);
subplot(1,1,1);
plot(arr, output);

[boat_M, boat_N] = size(boat);
img_rc = zeros(boat_M, boat_N);
mse_q = 0;
total_coff = 0;

for i = 1:boat_M/M
    for j = 1:boat_N/M
        img_block = boat((i-1)*M+1:M*i,(j-1)*M+1:M*j); % index of the row: (i-1)*M+1:M*i, index of the column: (j-1)*M+1:M*j
        img_dct = dct2(img_block); % DCT
        A = dct2matrixA(M); % get the matrix A to reconstruct the image
        img_q = quantizer(img_dct, 1); % quantizer
        mse_q = mse_q + mse(img_dct, img_q);
        total_coff = total_coff+1;
        img_rc((i-1)*M+1:M*i,(j-1)*M+1:M*j) = A'*img_q*A; % reconstructed image
    end
end

mse_q = mse_q/total_coff; % the mse between original and the quantized dct coeffs
d = mse(boat, img_rc); % d = the mse between original and the reconstructed image

