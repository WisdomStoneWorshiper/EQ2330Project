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
        [img_dct, A] = mydct2(img_block, M); % DCT
        img_q = round(img_dct); % quantizer
        mse_q = mse_q + sum((img_dct(:)-img_q(:)).^2)/length(img_dct(:));
        img_rc((i-1)*M+1:M*i,(j-1)*M+1:M*j) = A'*img_q*A; % reconstructed (IDCT)
    end
end

mse_q = mse_q/(size_img(1)/M*size_img(2)/M); % the mse between original and the quantized dct coeffs
d = sum((img(:)-img_rc(:)).^2)/length(img(:)); % d = the mse between original and the reconstructed image
psnr = 10*log10(255^2/d); % psnr for 8-bit images
