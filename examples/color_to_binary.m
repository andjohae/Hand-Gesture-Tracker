addpath(genpath('./lib/'))

I = imread('images/images-04-29/redBack3.jpg');

figure(1); clf
imshow(I)

I_hsv = rgb2hsv(I);
I_ycc = rgb2ycbcr(I);

%-------------------------
% HSV

figure(2); clf
subplot(2,3,1)
imshow(I_hsv(:,:,1))
subplot(2,3,2)
imshow(I_hsv(:,:,2))
title('HSV')
subplot(2,3,3)
imshow(I_hsv(:,:,3))
title('Not used')

subplot(2,3,4)
imhist(I_hsv(:,:,1))
subplot(2,3,5)
imhist(I_hsv(:,:,2))
subplot(2,3,6)
imhist(I_hsv(:,:,3))


range_hsv = [0 0.5; 0.4 0.8];
bin_hsv = Hsv2Binary(I_rgb,range_hsv);
figure(3); clf
imshow(bin_hsv,[0 1])
title('HSV Binary')

%-------------------------

figure(4); clf
subplot(2,3,1)
imshow(I_ycc(:,:,1))
title('Not used')
subplot(2,3,2)
imshow(I_ycc(:,:,2))
title('YCC')
subplot(2,3,3)
imshow(I_ycc(:,:,3))

subplot(2,3,4)
imhist(I_ycc(:,:,1))
subplot(2,3,5)
imhist(I_ycc(:,:,2))
subplot(2,3,6)
imhist(I_ycc(:,:,3))

range_ycc = [100 130; 125 165];
bin_ycc = Ycc2Binary(I_rgb,range_ycc);
figure(5); clf
imshow(bin_ycc,[0 1])
title('YCC Binary')