function output = ifwt2d(LL, LH, HL, HH, LPF)
    img_length = length(LL);
    L = zeros([img_length*2,img_length]);
    H = zeros([img_length*2,img_length]);
    % first work on the vertical direction
    for y = 1:img_length
        L(:,y) = fwt_synthesis(LL(:,y).', LH(:,y).', LPF);
        H(:,y) = fwt_synthesis(HL(:,y).', HH(:,y).', LPF);
    end
    output = zeros([img_length*2,img_length*2]);
    % then work on the horizontal direction
    for x = 1:img_length*2
        output(x,:) = fwt_synthesis(L(x,:), H(x,:), LPF);
    end

end

