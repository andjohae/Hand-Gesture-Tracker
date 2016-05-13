%% Tests of moment invariant features (see Mattias Andersson and Hu)

clear all;
clc;
addpath(genpath('../'));

% Thoughts: the current methods uses the raw bwImg, i.e. the moments are
% taken with respect to the object area. The same method should(?) work on
% a pure perimeter image. Such an image is already available in
% GetFeatures(). 
% TODO: Refine moment generation in separate file!

%% Create binary image from thresholding on R-channel
img = imread('image1.jpg');
rc = img(:,:,1);
imgSize = size(rc);
threshold = MidwayThreshold(rc,200);
fprintf('Estimated threshold: %d\n',threshold);
bwImg = rc > threshold;

structuralElement = strel('disk',3);
bwImg = imopen(bwImg, structuralElement);

se = strel('square',3);
perimImg = bwImg - imerode(bwImg,se);
imshow(perimImg);
moments = GetMoments(perimImg);
disp(moments);

%% Normalize distribution!
bwImg = bwImg./sum(bwImg(:));

%% Central moments - translation invariant
[yLength, xLength] = size(bwImg);

meanX = sum(bwImg,1) * (1:xLength)';
meanY = sum(bwImg,2)' * (1:yLength)';
[Y, X] = meshgrid(yLength,xLength);

integrand = @(p,q) (X - meanX).^p .* (Y - meanY).^q .* bwImg;

centralMoment_11 = sum(sum( integrand(1,1) ));
centralMoment_20 = sum(sum( integrand(2,0) ));
centralMoment_02 = sum(sum( integrand(0,2) ));
centralMoment_30 = sum(sum( integrand(3,0) ));
centralMoment_21 = sum(sum( integrand(2,1) ));
centralMoment_12 = sum(sum( integrand(1,2) ));
centralMoment_03 = sum(sum( integrand(0,3) ));

%% Normalised moments - similitude/scale invariant
centralMoment_00 = sum(sum( integrand(0,0) ))

% NOTE: centralMoment_00 = 1, always if bwImg normalised!
% No need to normalise moments since the distribution is already
% normalised?

%% Moment invariants - rotation (and mirror?) invariant
