lena = imread('../images/lena512.bmp');

lenavec = lena(:); %image to vector
figure, histogram(lenavec); %plot histogram
imhist(lena); %display image
lenalowcont = lowcontrastfnct(0.2,50,lena); %function to generate a low contrast image
imagesc(lenalowcont, [0 255]);
figure,histogram(lenalowcont);
imshow(lenalowcont);
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