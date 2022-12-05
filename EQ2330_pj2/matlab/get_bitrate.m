function [bitrate,entropy] = get_bitrate(img,step_len,M)
size_img = size(img);
size_block = size_img/M;
img_q = zeros(size_img);
for i = 1:size_block(1)
    for j = 1:size_block(2)
        img_block = img((i-1)*M+1:M*i,(j-1)*M+1:M*j);
        [img_dct,~] = mydct2(img_block,M); % DCT
        img_q = round(img_dct/step_len)*step_len; % quantizer
        img_q((i-1)*M+1:i*M,(j-1)*M+1:j*M) = img_q;
    end
end
K = zeros(8,8,64*64); 
entropy = zeros(M);
for m = 1:M
    for n = 1:M
        for p = 0:63
            for q = 0:63
                for idx = 1
                    K(m,n,idx) = img_q(8*p+m,8*q+n);
                    idx = idx + 1;
                end
            end
        end
    end
end

for m = 1:M
    for n = 1:M
        val = K(m,n,:);
        bins= min(val):step_len:max(val);
        pr = hist(val(:),bins(:));
        prb = pr/sum(pr);
        etrpy = -sum(prb.*log2(prb+eps));
        entropy(m,n) = etrpy;
    end
end
bitrate = mean(entropy(:));
end