lena = imread('../images/lena512.bmp');
%baboon = imread('images\baboon512.bmp');
%cabin = imread('images\cabin512.bmp');
%boats = imread('images\boats512_outoffocus.bmp');
%goldhill = imread("images\goldhill512.bmp");
%man = imread("images\man512_outoffocus.bmp");

imhist(lena);
lenavec = lena(:);
figure, histogram(lenavec);
imhist(lena);
%imshow(lena);

lenalowcont = lowcontrastfnct(0.2,50,lena);
imagesc(lenalowcont, [0 255]);
figure,histogram(lenalowcont);
imshow(lenalowcont);
%imhist(lenalowcont);
ylim([0,30000])

%histogram equalization without using histeq()

%Find the histogram of the image.
Val=reshape(lenalowcont,[],1);
Val=double(Val);
I = hist(Val,0:255);
%Divide the result by number of pixels
Output = I/numel(lenalowcont);
%Calculate the Cumlative sum
CSum=cumsum(Output);
%Perform the transformation S=T(R) where S and R in the range [0 1]
HIm=CSum(lenalowcont+1)*255;
imshow(HIm);
figure,histogram(HIm);

%lenahisteq = histeq(lenalowcont);
%imhist(lenahisteq);