%set(0,'DefaultFigureWindowStyle','docked')
addpath(genpath('./lib/'))

I = imread('images/handAndFaceImages/handAndFace3.jpg');
%I = imread('images/images-04-26/shirt2.jpg');
%I = imread('images/image3.jpg');

fig1 = figure(1); clf
imshow(I)

I_hsv = rgb2hsv(I);
I_ycc = rgb2ycbcr(I);

I_norm = double(I);
I_sqrt_sum = sqrt(sum(I_norm.^2,3));

I_sum = sum(I,3);
redNorm = I_norm(:,:,1) ./ I_sum;
greenNorm = I_norm(:,:,2) ./ I_sum;
blueNorm = I_norm(:,:,3) ./ I_sum;

redNorm2 = I_norm(:,:,1) ./ I_sqrt_sum;
greenNorm2 = I_norm(:,:,2) ./ I_sqrt_sum;
blueNorm2 = I_norm(:,:,3) ./ I_sqrt_sum;

%-------------------------
% RGB1

fig2 = figure(2); clf
subplot(2,3,1)
imshow(redNorm)
title('r')
subplot(2,3,2)
imshow(greenNorm)
title('g')
subplot(2,3,3)
imshow(blueNorm)
title('b')

subplot(2,3,4)
imhist(redNorm)
subplot(2,3,5)
imhist(greenNorm)
subplot(2,3,6)
imhist(blueNorm)

%-------------------------
% RGB2

fig3 = figure(3); clf
subplot(2,3,1)
imshow(redNorm2)
title('x')
subplot(2,3,2)
imshow(greenNorm2)
title('y')
subplot(2,3,3)
imshow(blueNorm2)
title('z')

subplot(2,3,4)
imhist(redNorm2)
subplot(2,3,5)
imhist(greenNorm2)
subplot(2,3,6)
imhist(blueNorm2)


%-------------------------
% HSV

fig4 = figure(4); clf
subplot(2,3,1)
imshow(I_hsv(:,:,1))
title('H')
subplot(2,3,2)
imshow(I_hsv(:,:,2))
title('S')
subplot(2,3,3)
imshow(I_hsv(:,:,3))
title('V')



subplot(2,3,4)
imhist(I_hsv(:,:,1))
subplot(2,3,5)
imhist(I_hsv(:,:,2))
subplot(2,3,6)
imhist(I_hsv(:,:,3))


%-------------------------

fig5 = figure(5); clf
subplot(2,3,1)
imshow(I_ycc(:,:,1))
title('Y')
subplot(2,3,2)
imshow(I_ycc(:,:,2))
title('Cb')
subplot(2,3,3)
imshow(I_ycc(:,:,3))
title('Cr')

subplot(2,3,4)
imhist(I_ycc(:,:,1))
subplot(2,3,5)
imhist(I_ycc(:,:,2))
subplot(2,3,6)
imhist(I_ycc(:,:,3))

%--------------------------

fig6 = figure(6); clf
subplot(2,2,1)
bin_norm = Rgb2Binary(I);
imshow(bin_norm,[0 1])
title('rgb')
subplot(2,2,2)
bin_norm2 = Rgb2Binary2(I);
imshow(bin_norm2,[0 1])
title('xyz')
subplot(2,2,3)
bin_hsv = Hsv2Binary(I);
imshow(bin_hsv,[0 1])
title('HSV')
subplot(2,2,4)
bin_ycc = Ycc2Binary(I);
imshow(bin_ycc,[0 1])
title('YCC')


%-----------------------------

fig7 = figure(7); clf
subplot(2,2,1)
I_gray = Ycc2Gray(I);
imshow(I_gray);
subplot(2,2,3:4)
hist(I_gray(:), 50);
subplot(2,2,2)
%imshow(I_gray < LowerThreshold(I_gray));
imshow(I_gray < .25);

%%

print(fig1,'-depsc','~/tmp/figures/hand_ref')
print(fig2,'-depsc','~/tmp/figures/dims_rgb1')
print(fig3,'-depsc','~/tmp/figures/dims_rgb2')
print(fig4,'-depsc','~/tmp/figures/dims_hsv')
print(fig5,'-depsc','~/tmp/figures/dims_ycbcr')
print(fig6,'-depsc','~/tmp/figures/binaries')
print(fig7,'-depsc','~/tmp/figures/ycc_histogram')
