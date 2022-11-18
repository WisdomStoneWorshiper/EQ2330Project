function f_hat = wiener_filter(g, h, K)
    [g_M, g_N] = size(g);
    [h_M, h_N] = size(h);
    disp(size(g));
    disp(size(h));
    g_padded = padarray(g, size(h),'symmetric');

    imagesc((g_padded));
    colormap gray(256);
    figure
    disp(size(g_padded));
    [M, N] = size(g_padded);
    H = fft2(h, M, N);
    G = fft2(g_padded);
    filter = (1./H) .* ((abs(H).^2) ./ (abs(H).^2 + K));
    F_hat = G .* filter;
    f_hat = abs(ifft2(F_hat));
    

%     f_hat = f_hat(h_M+1:h_M+g_M, h_N+1:h_N+g_N);
end
