f = imread("../images/lena512.bmp");

r = 8; % from the instruction
h = myblurgen('gaussian', r);
g = conv2(f, h, 'same');
[x_max, y_max] = size(g);
for i = 1:x_max
    for j = 1:y_max
        g(i,j) = min([max([g(i,j),0]), 255]);
    end
end


imagesc(f);
colormap gray(256);
figure, imagesc(g);
colormap gray(256);