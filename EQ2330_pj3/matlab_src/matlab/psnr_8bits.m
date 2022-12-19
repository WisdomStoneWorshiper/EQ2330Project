function output = psnr_8bits(img1, img2)
    output = 10 * log10((255 ^ 2) / mse(img1, img2));
end
