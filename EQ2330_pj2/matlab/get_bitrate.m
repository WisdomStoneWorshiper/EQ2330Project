function [bitrate,entropys] = get_bitrate(img,step,M)
size_img = size(img);
img_q = zeros(size_img);
for i = 1:size_img(1)/M
    for j = 1:size_img(2)/M
        [img_dct,~] = mydct2(img((i-1)*M+1:M*i,(j-1)*M+1:M*j),M); % DCT
        img_q((i-1)*M+1:i*M,(j-1)*M+1:j*M) = quantizer(img_dct,step); % quantizer
    end
end
K = zeros(8,8,64*64); 
entropys = zeros(M);
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
        bins= min(val):step:max(val);
        pr = hist(val(:),bins(:));
        prb = pr/sum(pr);
        etropy = -sum(prb.*log2(prb+eps));
        entropys(m,n) = etropy;
    end
end
bitrate = mean(entropys(:));
end