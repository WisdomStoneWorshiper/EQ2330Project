function mse = get_mse(img,step,M) % get the MSE between original and the reconstructed image
size_img = size(img);
size_block = size_img/M;
img_rc = zeros(size_img);

for i = 1:size_block(1)
    for j = 1:size_block(2)
        img_block = img((i-1)*M+1:i*M,(j-1)*M+1:j*M); 
        [img_dct,A] = mydct2(img_block,M); % DCT
        img_q = quantizer(img_dct, step); % quantizer
        img_rc((i-1)*M+1:i*M,(j-1)*M+1:j*M) = A'*img_q*A; % reconstructed = IDCT
    end
end
[m,n] = size(img);
mse = sum((img(:)-img_rc(:)).^2)/(m*n);
end
