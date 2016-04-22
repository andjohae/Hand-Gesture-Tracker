clc
clear all
%%
I = imread('images/image1.jpg');
figure(1); hold on
imshow(I);

%%
rc = double(I(:,:,1));
gc = double(I(:,:,2));
bc = double(I(:,:,3));

%R = R / sum(R G B)
%R = R / sqrt(sum(R^2 G^2 B^2)
color_sum = rc + gc + bc;
color_sum2 = sqrt(rc.^2 + gc.^2 + bc.^2);

rcn = 255 * rc ./ color_sum;
gcn = 255 * gc ./ color_sum;
bcn = 255 * bc ./ color_sum;

rcn2 = 255 * rc ./ color_sum2;
gcn2 = 255 * gc ./ color_sum2;
bcn2 = 255 * bc ./ color_sum2;

%%
n = 10;
rgb = zeros(n,3);
rgbn = zeros(n,3);
rgbn2 = zeros(n,3);

for k = 1:n
    c = ginput(1);
    c = round(c);
    i = c(2);
    j = c(1);
    rgb(k,:) = [rc(i,j) gc(i,j) bc(i,j)];
    rgbn(k,:) = [rcn(i,j) gcn(i,j) bcn(i,j)];
    rgbn2(k,:) = [rcn2(i,j) gcn2(i,j) bcn2(i,j)];
    plot(c(1),c(2),'r.')
end

mu = mean(rgb);
mun = mean(rgbn);
mun2 = mean(rgbn2);

%%
figure(2); clf
I_norm1 = ones(size(rc,1),size(rc,2));
I_norm2 = ones(size(rc,1),size(rc,2));
I_norm3 = ones(size(rc,1),size(rc,2));

for i = 1:size(I,1)
  for j = 1:size(I,2)
    I_norm1(i,j) = 255 - norm([rc(i,j) gc(i,j) bc(i,j)] - mu,2);
    I_norm2(i,j) = 255 - norm([rcn(i,j) gcn(i,j) bcn(i,j)] - mu,2);
    I_norm3(i,j) = 255 - norm([rcn2(i,j) gcn2(i,j) bcn2(i,j)] - mu,2);
  end
end
subplot(1,3,1)
imshow(I_norm1,[0 255])
subplot(1,3,2)
imshow(I_norm2,[0 255])
subplot(1,3,3)
imshow(I_norm3,[0 255])

%%
figure(3); clf
subplot(1,3,1)
imhist(I_norm1/255)
subplot(1,3,2)
imhist(I_norm2/255)
subplot(1,3,3)
imhist(I_norm3/255)


%%
figure(4); clf
subplot(1,3,1)
imshow(I_norm1 > 150)
subplot(1,3,2)
imshow(I_norm2 > 40)
subplot(1,3,3)
imshow(I_norm3 > 135)


%%


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
%R = R / sqrt(sum(R^2 G^2 B^2)