clc
clear all
addpath ./lib/analysis_modules/
%%
I = imread('images/signesImage1.jpg');
figure(1); clf; hold on
imshow(I);

%%
I = double(I);

red = I(:,:,1);
green = I(:,:,2);
blue = I(:,:,3);

sumImage = sqrt(sum(I,3));
redNorm1 = 255 * I(:,:,1) ./ sumImage;
greenNorm1 = 255 * I(:,:,2) ./ sumImage;
blueNorm1 = 255 * I(:,:,3) ./ sumImage;

sqrtSumImage = sqrt(sum(I.^2,3));
redNorm2 = 255 * I(:,:,1) ./ sqrtSumImage;
greenNorm2 = 255 * I(:,:,2) ./ sqrtSumImage;
blueNorm2 = 255 * I(:,:,3) ./ sqrtSumImage;

% Sample means
n = 10;
rgb1 = zeros(n,3);
rgb2 = zeros(n,3);
rgb3 = zeros(n,3);

for k = 1:n
    c = ginput(1);
    c = round(c);
    i = c(2);
    j = c(1);
    rgb1(k,:) = [red(i,j) green(i,j) blue(i,j)];
    rgb2(k,:) = [redNorm1(i,j) greenNorm1(i,j) blueNorm1(i,j)];
    rgb3(k,:) = [redNorm2(i,j) greenNorm2(i,j) blueNorm2(i,j)];
    plot(c(1),c(2),'r.')
end

mu1 = mean(rgb1);
mu2 = mean(rgb2);
mu3 = mean(rgb3);


%%
figure(2); clf


gray1 = Mean2Gray1(I,mu1);
subplot(2,3,1);
imshow(gray1,[0 255]);
subplot(2,3,4);
imhist(gray1/255);

gray2 = Mean2Gray2(I,mu2);
subplot(2,3,2);
imshow(gray2,[0 255]);
subplot(2,3,5);
imhist(gray2/255);

gray3 = Mean2Gray3(I,mu3);
subplot(2,3,3);
imshow(gray3,[0 255]);
subplot(2,3,6);
imhist(gray3/255);

%%
figure(7); clf
subplot(1,3,1)
histogram(I_norm1,0:255)
subplot(1,3,2)
histogram(I_norm2,0:255)
subplot(1,3,3)
histogram(I_norm3,0:255)
%%
figure(8); clf
subplot(1,3,1)
imshow(I_norm1 > 205)
subplot(1,3,2)
imshow(I_norm2 > 218)
subplot(1,3,3)
imshow(I_norm3 > 165)

%%
G = rgb2gray(I);
figure(2)
imshow(G)

figure(3)
imhist(G)
%%
Ibin = G > 170;
figure(4); clf
%imshow(Ibin)
se = strel('disk',3);
subplot(1,2,1)
Im = imerode(Ibin,se);
imshow(Im)
subplot(1,2,2)
Im = imdilate(Im,se);
imshow(Im)
%%
figure(5); clf

Isum = I(:,:,1) + I(:,:,2) + I(:,:,3);
Ir=double(I(:,:,1))./double(Isum);
Ig=double(I(:,:,2))./double(Isum);
Ib=double(I(:,:,3))./double(Isum);

subplot(2,3,1)
imshow(Ir)
subplot(2,3,2)
imshow(Ig)
subplot(2,3,3)
imshow(Ib)

Isum2 = sqrt(double(I(:,:,1)).^2 + double(I(:,:,2)).^2 + double(I(:,:,3)).^2);
Irn=double(I(:,:,1))./double(Isum2);
Ign=double(I(:,:,2))./double(Isum2);
Ibn=double(I(:,:,3))./double(Isum2);

subplot(2,3,4)
imshow(Irn)
subplot(2,3,5)
imshow(Ign)
subplot(2,3,6)
imshow(Ibn)

%%
figure(7); clf
subplot(1,3,1)
imhist(Ir)
subplot(1,3,2)
imhist(Ig)
subplot(1,3,3)
imhist(Ib)

%%
ginput(1)
rgb = zeros(10,3);
t = 0:255;

for i = 1:10
    c = ginput(1);
    c = round(c);
    rgb(i,:) = I(c(1),c(2),:);
end
%%
figure(6); clf
mu = mean(rgb);
s = std(rgb);clf; hold on
plot(t,normpdf(t,mu(1),s(1)),'r')
plot(t,normpdf(t,mu(2),s(2)),'g')
plot(t,normpdf(t,mu(3),s(3)),'b')

%%
I_norm = ones(size(I,1),size(I,2));

for i = 1:size(I,1)
  for j = 1:size(I,2)
    I_norm(i,j) = mvnpdf(double([I(i,j,1) I(i,j,2) I(i,j,3)]),mu, cov(rgb));
  end
end
sum(sum(I_norm))

%%
figure(8); clf
I_cart = ones(size(I,1),size(I,2));

for i = 1:size(I,1)
  for j = 1:size(I,2)
    I_cart(i,j) = norm(double([I(i,j,1) I(i,j,2) I(i,j,3)].^2) - mu);
    %I_cart(i,j) = norm(double([Ir(i,j) Ig(i,j) Ib(i,j)]) - mu/255);
    %I_cart(i,j) = norm(double([Irn(i,j) Ign(i,j) Ibn(i,j)]) - mu/255);
  end
end
imshow(I_cart,[0 255]);
%imshow(I_cart);

%%
clc
I = imread('images/image1.jpg');
figure(1)
%imshow(I);

Ired = I(:,:,1);
subplot(1,2,1);
imshow(Ired)

subplot(1,2,2)
imshow(RedChannel2Binary(I));

%R = R / sum(R G B)
%R = R / sqrt(sum(R^2 G^2 B^2)foo
