addpath(genpath('./lib/'))

%I = imread('images/image1.jpg');
I = imread('~/tmp/Hands/out.jpg');

figure(1); clf
imshow(I)

I_hsv = rgb2hsv(I);
I_ycc = rgb2ycbcr(I);

I_norm = double(I);
I_sum = sum(I,3);
redNorm = I_norm(:,:,1) ./ I_sum;
greenNorm = I_norm(:,:,2) ./ I_sum;
blueNorm = I_norm(:,:,3) ./ I_sum;

%-------------------------
% RGB

figure(2); clf
subplot(2,3,1)
imshow(redNorm)
subplot(2,3,2)
imshow(greenNorm)
title('RGB')
subplot(2,3,3)
imshow(blueNorm)

subplot(2,3,4)
imhist(redNorm)
subplot(2,3,5)
imhist(greenNorm)
subplot(2,3,6)
imhist(blueNorm)


bin_norm = Rgb2Binary(I);
figure(3); clf
imshow(bin_norm,[0 1])
title('Norm Binary')


%-------------------------
% HSV

figure(4); clf
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


bin_hsv = Hsv2Binary(I);
figure(5); clf
imshow(bin_hsv,[0 1])
title('HSV Binary')

%-------------------------

figure(6); clf
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

bin_ycc = Ycc2Binary(I);
figure(7); clf
imshow(bin_ycc,[0 1])
title('YCC Binary')