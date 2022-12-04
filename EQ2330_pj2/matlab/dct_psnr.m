% 2.3-1
% DCT PSNR
% The average distortion d will be the mean squared error between the original and the 
% reconstructed images. Compare d with the mean squared error between the original and 
% the quantized DCT coefficients. How do they compare and why?

img = double(imread('../images/boats512x512.tif'));
size_img = size(img);
size_block = size_img/M;
img_rc = zeros(size_img);
M = 8;
step_len = 1;
mse_q = 0;

for i = 1:size_block(1)
    for j = 1:size_block(2)
        r_idx = (i-1)*M+1:i*M;
        c_idx = (j-1)*M+1:j*M;
        img_block = img(r_idx,c_idx);
        [img_dct, A] = mydct2(img_block, M); % DCT
        img_q = round(img_dct/step_len)*step_len; % quantizer
        img_idct = A'*img_q*A; % IDCT
        img_rc(r_idx,c_idx) = img_idct;
        mse_q = mse_q + sum((img_dct(:)-img_q(:)).^2)/length(img_dct(:));
    end
end

mse_q = mse_q/(size_block(1)*size_block(2)); % mse between original and the quantized DCT coefficient

d = sum((img(:)-img_rc(:)).^2)/length(img(:)); % d = mse between original and the reconstructed image

% PSNR
psnr = 10*log10(255^2/d);
