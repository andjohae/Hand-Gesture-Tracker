%% Initialize and read image
clc;
clear all;

addpath( genpath('../') );

imgPath = '../images/demo.jpg';
bwImg = im2bw(imread(imgPath));
imshow(bwImg);

%% Extract features
structuralElement = strel('square',3);

% Object perimeter
perimeterImg = bwImg - imerode(bwImg, structuralElement); 

% Object area
filledImg = imfill(perimeterImg);

% Convex area
convexHullImg = bwconvhull( filledImg );

% Convex perimeter
convexPerimeterImg = convexHullImg - imerode(convexHullImg,structuralElement);

%% Draw images
h_fig1 = figure(1);
clf(h_fig1);
imshow(perimeterImg);

%%
h_fig2 = figure(2);
clf(h_fig2);
% imshow(bwImg);
[row, col] = ind2sub(size(bwImg),find(convexPerimeterImg));
hold on
  h_convPerim = plot(row,col,'r');
hold off