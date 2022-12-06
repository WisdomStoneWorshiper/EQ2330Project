% 2.3-1 DCT PSNR
clear;
M = 8;
img = double(imread('../images/boats512x512.tif'));
size_img = size(img);
img_rc = zeros(size_img);
mse_q = 0;

for i = 1:size_img(1)/M
    for j = 1:size_img(2)/M
        img_block = img((i-1)*M+1:M*i,(j-1)*M+1:M*j); % index of the row: (i-1)*M+1:M*i, index of the column: (j-1)*M+1:M*j
        img_dct = dct2(img_block); % DCT
        A = dct2matrixA(M); % get the matrix A to reconstruct the image
        img_q = quantizer(img_dct, 1); % quantizer
        mse_q = mse_q + sum((img_dct(:)-img_q(:)).^2)/length(img_dct(:));
        img_rc((i-1)*M+1:M*i,(j-1)*M+1:M*j) = A'*img_q*A; % reconstructed image
    end
end

mse_q = mse_q/(size_img(1)/M*size_img(2)/M); % the mse between original and the quantized dct coeffs
d = mse(img, img_rc); % d = the mse between original and the reconstructed image
