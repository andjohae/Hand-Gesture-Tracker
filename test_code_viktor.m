clc
clear all
I = imread('images/image1.jpg');
figure(1)
imshow(I);

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

subplot(1,3,1)
imshow(Ir)
subplot(1,3,2)
imshow(Ig)
subplot(1,3,3)
imshow(Ib)

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
%mvnpdf(X,MU,SIGMA) 
phat = mle(rgb,'distribution','mvn')