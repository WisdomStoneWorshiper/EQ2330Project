function [bitrate,entropy] = mybitrate(img,step_len,M)
size_img = size(img);
size_block = size_img/M;
img_q = zeros(size_img);
for i = 1:size_block(1)
    for j = 1:size_block(2)
        r_idx = (i-1)*M+1:i*M;
        c_idx = (j-1)*M+1:j*M;
        img_block = img(r_idx,c_idx);
        [img_dct,~] = mydct2(img_block,M); % DCT
        img_q = round(img_dct/step_len)*step_len; % quantizer
        img_q(r_idx,c_idx) = img_q;
    end
end
K = zeros(8,8,64*64); 
entropy = zeros(M);
for m = 1:M
    for n = 1:M
        for idx = 1
            for p = 0:63
                for q = 0:63
                    K(m,n,idx) = img_q(m+8*p,n+8*q);
                    idx = idx + 1;
                end
            end
        end
    end
end

for m = 1:M
    for n = 1:M
        value = K(m,n,:);
        bins= min(value):step_len:max(value);
        pr = hist(value(:),bins(:));
        prb = pr/sum(pr);
        etrpy = -sum(prb.*log2(prb+eps));
        entropy(m,n) = etrpy;
    end
end
bitrate = mean(entropy(:));
end