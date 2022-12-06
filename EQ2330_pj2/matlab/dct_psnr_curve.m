% 2.3-2 rate-PSNR curve
clc;
clear;
img_b = double(imread('../images/boats512x512.tif'));
img_h = double(imread('../images/harbour512x512.tif'));
img_p = double(imread('../images/peppers512x512.tif'));
bitrate = zeros(1, 10);
psnr = zeros(1, 10);
M = 8;
sizeb = size(img_b);
sizeh = size(img_h);
sizep = size(img_p);
img_rc_b = zeros(sizeb);
img_rc_h = zeros(sizeh);
img_rc_p = zeros(sizep);

% reconstruct image b
for i = 1:sizeb/M
    for j = 1:sizeb/M
        img_block = img_b((i-1)*M+1:i*M,(j-1)*M+1:j*M); 
        img_dct = dct2(img_block); % DCT
        A = dct2matrixA(M); % get the matrix A to reconstruct the image
        img_q = quantizer(img_dct, step); % quantizer
        img_rc_b((i-1)*M+1:i*M,(j-1)*M+1:j*M) = A'*img_q*A; % reconstructed image
    end
end

% reconstruct image h
for i = 1:sizeh/M
    for j = 1:sizeh/M
        img_block = img_h((i-1)*M+1:i*M,(j-1)*M+1:j*M); 
        img_dct = dct2(img_block); % DCT
        A = dct2matrixA(M); % get the matrix A to reconstruct the image
        img_q = quantizer(img_dct, step); % quantizer
        img_rc_h((i-1)*M+1:i*M,(j-1)*M+1:j*M) = A'*img_q*A; % reconstructed image
    end
end

% reconstruct image p
for i = 1:sizep/M
    for j = 1:sizep/M
        img_block = img_p((i-1)*M+1:i*M,(j-1)*M+1:j*M); 
        img_dct = dct2(img_block); % DCT
        A = dct2matrixA(M); % get the matrix A to reconstruct the image
        img_q = quantizer(img_dct, step); % quantizer
        img_rc_p((i-1)*M+1:i*M,(j-1)*M+1:j*M) = A'*img_q*A; % reconstructed image
    end
end

for i = 0:9
    mses = [mse(img_b, img_rc_b) mse(img_h, img_rc_h) mse(img_p, img_rc_p)];
    d = mean(mses);
    psnr(i) = 10*log10(255^2/d);
    [bitrates(1),entropy_1] = get_bitrate(img_b,2^i,M);
    [bitrates(2),entropy_2] = get_bitrate(img_h,2^i,M);
    [bitrates(3),entropy_3] = get_bitrate(img_p,2^i,M);
    
    if (i == 6)
        entropy = (entropy_1+entropy_2+entropy_3)/3;
        figure;
        surf(entropy);
        title('Average entropy of the DCT coefficients');
    end
    bitrate(i+1) = mean(bitrates);
end