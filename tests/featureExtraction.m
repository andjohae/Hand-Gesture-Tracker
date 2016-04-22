%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Tests for feature extraction %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;

pathParts = strsplit(pwd,'/');
isCorrectPWD = strcmp(pathParts(end), 'tests');
if ~isCorrectPWD
  disp('Wrong working directory!');
  break;
end

% Initialization
addpath('../images');
addpath('../lib/analysis_modules/');

% Read images
img = imread('image1.jpg'); 
figure(1);
imshow(img);

%% Create binary image from thresholding on R-channel
clc;
rc = img(:,:,1);
imgSize = size(rc);
threshold = MidwayThreshold(rc,200);
fprintf('Estimated threshold: %d\n',threshold);
bwImg = rc > threshold;

structuralElement = strel('disk',3);
bwImg = imopen(bwImg, structuralElement);

imshow(bwImg)

%% Perimeter
boundaryIndex = ExtractObjectBoundary(bwImg);
boundaryImg = zeros(imgSize);
boundaryImg(boundaryIndex) = 1;
imshow(boundaryImg);

% % Draw with
[Y,X] = ind2sub(imgSize,boundaryIndex);
% hold on;
%   plot(X,Y,'k','LineWidth',2);
% hold off;

CONST_4 = 4*sqrt(2)/pi;
perimeter = length(boundaryIndex); % /CONST_4 % in Lecture notes!
fprintf('Perimeter: %.2f\n',perimeter);

%% Compactness
% % Uncomment the section if you want to use 'FillAreaInsideBoundary()'
% [Y,X] = ind2sub(imgSize,boundaryIndex);
% seedIndex = round( mean( [Y, X] ) );
% seedIndex = sub2ind(imgSize,seedIndex(1),seedIndex(2));
% filledBWImg = FillAreaInsideBoundary(boundaryIndex,imgSize,seedIndex);

filledBWImg = imfill(boundaryImg);
imshow(filledBWImg);

area = sum(filledBWImg(:));

compactness = area./(perimeter.^2); % *4*pi % in Lecture notes!
fprintf('Compactnes: %.3f\n',compactness);


%% Convexity
convexHullIndices = convhull(X,Y);
convexHullImg = zeros(imgSize);
convexHullImg(convexHullIndices) = 1;
imshow(convexHullImg);





























