function output = get_mse(img,step,M) % get the MSE between original and the reconstructed image
size_img = size(img);
img_rc = zeros(size_img);

for i = 1:size_img(1)/M
    for j = 1:size_img(2)/M
        img_block = img((i-1)*M+1:i*M,(j-1)*M+1:j*M); 
        img_dct = dct2(img_block); % DCT
        A = dct2matrixA(M); % get the matrix A to reconstruct the image
        img_q = quantizer(img_dct, step); % quantizer
        img_rc((i-1)*M+1:i*M,(j-1)*M+1:j*M) = A'*img_q*A; % reconstructed image
    end
end
output = mse(img, img_rc);
end
