addpath(genpath('./lib/'))
addpath(genpath('./images/'))

%I = imread('images/image3.jpg');
I = imread('images/sequenceImages-05-02/im3.jpg');
%I = imread('images/handAndFaceImages/handAndFace3.jpg');

figure(1); clf
imshow(I)

se = strel('disk',4);

figure(4); clf
bin_ycc = Ycc2Binary(I);
bin_ycc = imopen(bin_ycc, se);
imshow(bin_ycc);
title('YCC')

feature_choice = [3:4];

% YCC
figure(4); hold on
ycc_regions = regionprops(bin_ycc);
ycc_large = cat(1,ycc_regions.Area) > 500;
ycc_bb = cat(1, ycc_regions.BoundingBox);
ycc_bb = ycc_bb(ycc_large,:);

for i = 1:size(ycc_bb,1)
  tmp = GetFeatures(imcrop(bin_ycc,ycc_bb(i,:)));
  if ClassifyWithMinMax(tmp(feature_choice), feature_choice)
    rectangle('position',ycc_bb(i,:), 'edgecolor','g')
  else
    rectangle('position',ycc_bb(i,:), 'edgecolor','r')
  end
end

%[featureMin;...
%GetFeatures(imcrop(bin_ycc,ycc_bb(1,:)));...
%featureMax]

%%

figure(2); clf
bin_norm = Rgb2Binary(I);
bin_norm = imopen(bin_norm, se);
imshow(bin_norm);
title('Normalized')

figure(3); clf
bin_hsv = Hsv2Binary(I);
bin_hsv = imclose(bin_hsv, se);
imshow(bin_hsv);
title('HSV')

% NORMALIZED
figure(2); hold on
norm_regions = regionprops(bin_norm);
norm_large = cat(1,norm_regions.Area) > 500;
norm_bb = cat(1, norm_regions.BoundingBox);
norm_bb = norm_bb(norm_large,:);

for i = 1:size(norm_bb,1)
  tmp = GetFeatures(imcrop(bin_norm,norm_bb(i,:)));
  if ClassifyWithMinMax(tmp(feature_choice), feature_choice)
    rectangle('position',norm_bb(i,:), 'edgecolor','g')
  else
    rectangle('position',norm_bb(i,:), 'edgecolor','r')
  end
end


% HSV
figure(3); hold on
hsv_regions = regionprops(bin_hsv);
hsv_large = cat(1,hsv_regions.Area) > 500;
hsv_bb = cat(1, hsv_regions.BoundingBox);
hsv_bb = hsv_bb(hsv_large,:);

for i = 1:size(hsv_bb,1)
  tmp = GetFeatures(imcrop(bin_hsv,hsv_bb(i,:)));
  if ClassifyWithMinMax(tmp(feature_choice), feature_choice)
    rectangle('position',hsv_bb(i,:), 'edgecolor','g')
  else
    rectangle('position',hsv_bb(i,:), 'edgecolor','r')
  end
end
