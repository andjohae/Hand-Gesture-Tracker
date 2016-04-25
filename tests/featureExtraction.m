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

[Y,X] = ind2sub(imgSize,boundaryIndex);
% hold on;
%   plot(X,Y,'k','LineWidth',2);
% hold off;

CONST_4 = 4*sqrt(2)/pi;
perimeter = length(boundaryIndex); % /CONST_4 % in Lecture notes!
fprintf('Perimeter:\t%d\n',perimeter);

%% Alternative perimiter extraction (as used by Mattias Andersson)
structElement_8way = strel('square',3);    % Use for 8-way connectivity
structElement_4way = strel('diamond',1);  % Use for 4-way connectivity
erodedImg = imerode(bwImg, structElement_8way);
perimeterImg = bwImg - erodedImg;
imshow(perimeterImg);

% Perimeter length:
perimeterAlt = length(find(perimeterImg));
fprintf('Perimeter:\t%d\t(alternative)\n',perimeterAlt);

% NOTE: The 8-way connectivity choice yields the same perimeter length as
% my old function 'ExtractOjbectBoundary'. 
% This new method should be a lot faster!

%% Compactness
% % Uncomment the section if you want to use 'FillAreaInsideBoundary()'
% [Y,X] = ind2sub(imgSize,boundaryIndex);
% seedIndex = round( mean( [Y, X] ) );
% seedIndex = sub2ind(imgSize,seedIndex(1),seedIndex(2));
% filledBWImg = FillAreaInsideBoundary(boundaryIndex,imgSize,seedIndex);

filledBWImg = imfill(boundaryImg);
imshow(filledBWImg);

area = sum(filledBWImg(:));
fprintf('Area:\t\t%d\n',area);

compactness = area./(perimeter.^2); % *4*pi % in Lecture notes!
fprintf('Compactness:\t%.5f\n',compactness);


%% Convexity
convexHullImg  = bwconvhull(filledBWImg);
imshow(convexHullImg);

convexBoundary = ExtractObjectBoundary(convexHullImg);
convexPerimeter = length(convexHullImg);

convexity = convexPerimeter./perimeter;

fprintf('Convexity:\t%.5f\n',convexity);

%% Thickness (as used by Mattias Andersson)
tmpBwImg = bwImg;
nErosions = 0;

while any(tmpBwImg(:))
  tmpBwImg = imerode(tmpBwImg, structElement_8way);
  nErosions = nErosions + 1;
end

fprintf('Number of erosions: %d\n', nErosions);
fprintf('Thickness: %d\n', 2*nErosions);

%% Mattias Andresson's shape independent features
% Formfactor = (4*pi) * Area / Perimeter^2
% Elongtedness = Area / Thickness^2
% Convexity = Convex_perimeter / Perimeter
% Solidity = Area / Convex_area

