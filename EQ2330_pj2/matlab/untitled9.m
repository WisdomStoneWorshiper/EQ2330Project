boat = imread("../images/boats512x512.tif");
boat8x8 = imresize(boat,[8 8]);
imshow(boat8x8);