function mse = get_mse(img,step_len,M) % get the MSE between original and the reconstructed image
size_img = size(img);
size_block = size_img/M;
img_rc = zeros(size_img);

for i = 1:size_block(1)
    for j = 1:size_block(2)
        img_block = img((i-1)*M+1:i*M,(j-1)*M+1:j*M); 
        [img_dct,A] = mydct2(img_block,M); % DCT
        img_q = round(img_dct/step_len)*step_len; % quantizer
        img_idct = A'*img_q*A; % inverse DCT
        img_rc((i-1)*M+1:i*M,(j-1)*M+1:j*M) = img_idct;
    end
end
[m,n] = size(img);
mse = sum((img(:)-img_rc(:)).^2)/(m*n);
end
