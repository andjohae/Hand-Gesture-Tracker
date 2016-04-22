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
img = imread('image3.jpg'); 
imgSize = size(img);
figure(1);
imshow(img);

%% Create bw image from thresholding on R-channel
clc;
rc = img(:,:,1);
threshold = MidwayThreshold(rc,200)
bwImg = rc > threshold;

structuralElement = strel('disk',3);
bwImg = imopen(bwImg, structuralElement);

imshow(bwImg);

%% Perimeter
boundary = ExtractObjectBoundary(bwImg);
[Y,X] = ind2sub(imgSize,boundary);
hold on;
  plot(X,Y,'r','LineWidth',2);
hold off;

CONST_4 = 4*sqrt(2)/pi;
perimeter = length(boundary)/CONST_4;
fprintf('Perimeter: %.2f\n',perimeter);

%% Compactness


%% Convexity


