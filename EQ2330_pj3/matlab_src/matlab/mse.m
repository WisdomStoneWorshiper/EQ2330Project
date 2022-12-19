function output = mse(img1, img2)
    [M, N] = size(img1);
    output = sum((img1(:) - img2(:)) .^ 2) / (M * N);
end
