function f_hat = wiener_filter(g, h, K)
    [g_M, g_N] = size(g);
    [h_M, h_N] = size(h);
    % apply padding which reflect the edges pixels
    g_padded = padarray(g, size(h), 'symmetric');

    [M, N] = size(g_padded);
    % make the size of H same as G for calculation purpose
    H = fft2(h, M, N);
    G = fft2(g_padded);
    % equation of the wiener filter
    filter = (1 ./ H) .* ((abs(H).^2) ./ (abs(H).^2 + K));
    % apply wiener filter to the blurred image
    F_hat = G .* filter;
    f_hat = abs(ifft2(F_hat));
    %remove the padding
    f_hat = f_hat(ceil(double(h_M) / 2):ceil(double(h_M) / 2) + g_M - 1, ceil(double(h_N) / 2):ceil(double(h_N) / 2) + g_N - 1);
end
