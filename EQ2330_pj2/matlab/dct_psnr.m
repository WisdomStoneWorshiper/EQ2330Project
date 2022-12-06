% 2.3-1 DCT PSNR
M = 8;
harbours = double(imread('../images/boats512x512.tif'));
[boat_M, boat_N] = size(harbours);
img_rc = zeros(boat_M, boat_N);
mse_q = 0;
total_coff = 0;

for i = 1:boat_M/M
    for j = 1:boat_N/M
        img_block = harbours((i-1)*M+1:M*i,(j-1)*M+1:M*j); % index of the row: (i-1)*M+1:M*i, index of the column: (j-1)*M+1:M*j
        img_dct = dct2(img_block); % DCT
        A = dct2matrixA(M); % get the matrix A to reconstruct the image
        img_q = quantizer(img_dct, 1); % quantizer
        mse_q = mse_q + mse(img_dct, img_q);
        total_coff = total_coff+1;
        img_rc((i-1)*M+1:M*i,(j-1)*M+1:M*j) = A'*img_q*A; % reconstructed image
    end
end

mse_q = mse_q/total_coff; % the mse between original and the quantized dct coeffs
d = mse(harbours, img_rc); % d = the mse between original and the reconstructed image
