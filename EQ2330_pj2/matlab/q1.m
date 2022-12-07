clc;
clear;

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
plot_matrix(boat8x8);

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
        img_q = quantizer(img_dct, 1); % quantizer
        mse_q = mse_q + mse(img_dct, img_q);
        total_coff = total_coff+1;
        img_rc((i-1)*M+1:M*i,(j-1)*M+1:M*j) = A'*img_q*A; % reconstructed image
    end
end

mse_q = mse_q/total_coff; % the mse between original and the quantized dct coeffs
d = mse(boat, img_rc); % d = the mse between original and the reconstructed image



step_range = [2^0, 2^1, 2^2, 2^3, 2^4, 2^5, 2^6, 2^7, 2^8, 2^9];
[~, total_step_range] = size(step_range);
bitrates = zeros(10,64,64);
PSNRs = zeros(10, 3);

total_coff = 64;

for i = 1:total_step_range
    b_rc = zeros(size(boat));
    h_rc = zeros(size(harbours));
    p_rc = zeros(size(peppers));
    for j = 1:total_coff
        for k = 1:total_coff
            b_block = boat((j-1)*M+1:M*j,(k-1)*M+1:M*k); 
            h_block = harbours((j-1)*M+1:M*j,(k-1)*M+1:M*k); 
            p_block = peppers((j-1)*M+1:M*j,(k-1)*M+1:M*k); 

            b_dct = dct2(b_block); % DCT
            h_dct = dct2(h_block);
            p_dct = dct2(p_block);

            b_q = quantizer(b_dct, step_range(i)); % quantizer
            h_q = quantizer(h_dct, step_range(i));
            p_q = quantizer(p_dct, step_range(i));

            merged = [b_q(:), h_q(:), p_q(:)];
%             disp("i,j,k:"+i+ " "+ j+ " "+k);
%             test = bitrate(merged);
            bitrates(i,j,k) = bitrate(merged);

            b_rc((j-1)*M+1:M*j,(k-1)*M+1:M*k) = A'*b_q*A; % reconstructed image
            h_rc((j-1)*M+1:M*j,(k-1)*M+1:M*k) = A'*h_q*A;
            p_rc((j-1)*M+1:M*j,(k-1)*M+1:M*k) = A'*p_q*A;

        end
    end
    PSNRs(i,1) = psnr_8bits(boat, b_rc);
    PSNRs(i,2) = psnr_8bits(harbours, h_rc);
    PSNRs(i,3) = psnr_8bits(peppers, p_rc);
    
end

avg_PSNRs = mean(PSNRs,2);
avg_bitrates = mean(bitrates,2);
avg_bitrates = mean(avg_bitrates, 3);

[fwt_avg_bitrates, fwt_avg_PSNRs]=fwt_psnr_bitrate();

figure(2);

plot(avg_bitrates, avg_PSNRs, '-bo');
hold on;
plot(fwt_avg_bitrates, fwt_avg_PSNRs, '-ro');

xlabel("Bit-rates");
ylabel("PSNR");
legend("DCT", "FWT");
grid on;
