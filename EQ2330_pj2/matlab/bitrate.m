function entropy = bitrate(img)
    [M, N] = size(img);
    [pixel_counts, ~] = groupcounts(img(:));
    pixel_probas = nonzeros(pixel_counts(:)./(M*N));
    log_pixel_probas = log2(pixel_probas);
    entropy = -sum(pixel_probas.*log_pixel_probas);
end

