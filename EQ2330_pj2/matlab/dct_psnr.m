% 2.3-1 DCT PSNR
clear;
M = 8;
img = double(imread('../images/boats512x512.tif'));
size_img = size(img);
size_block = size_img/M;
img_rc = zeros(size_img);
step_len = 1;
mse_q = 0;

for i = 1:size_block(1)
    for j = 1:size_block(2)
        img_block = img((i-1)*M+1:M*i,(j-1)*M+1:M*j); % index of the row: (i-1)*M+1:M*i, index of the column: (j-1)*M+1:M*j
        [img_dct, A] = mydct2(img_block, M); % DCT
        img_q = round(img_dct/step_len)*step_len; % quantizer
        img_idct = A'*img_q*A; % IDCT
        mse_q = mse_q + sum((img_dct(:)-img_q(:)).^2)/length(img_dct(:));
        img_rc((i-1)*M+1:M*i,(j-1)*M+1:M*j) = img_idct;
    end
end

mse_q = mse_q/(size_block(1)*size_block(2)); % the mse between original and the quantized DCT coeff
d = sum((img(:)-img_rc(:)).^2)/length(img(:)); % d = the mse between original and the reconstructed image
psnr = 10*log10(255^2/d); % psnr for 8-bit images
