function [LL, LH, HL, HH] = fwt2d(img, LPF)
    img_length = length(img);
    L = zeros([img_length,img_length/2]);
    H = zeros([img_length,img_length/2]);
    % first work on the horizontal direction
    for x = 1:img_length
        [L(x,:),H(x,:)] = fwt_analysis(img(x,:),LPF);
    end
    LL = zeros([img_length/2,img_length/2]);
    LH = zeros([img_length/2,img_length/2]);
    HL = zeros([img_length/2,img_length/2]);
    HH = zeros([img_length/2,img_length/2]);
    % then work on the vertical direction
    for y = 1:img_length/2
        [LL(:,y),LH(:,y)] = fwt_analysis(L(:,y).',LPF);
        [HL(:,y),HH(:,y)] = fwt_analysis(H(:,y).',LPF);
    end
end
