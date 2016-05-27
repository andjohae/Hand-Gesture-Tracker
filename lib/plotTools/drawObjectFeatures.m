%% Initialize and read image
clc;
clear all;

addpath( genpath('./lib') );

imgPath = './images/demo_small.jpg';
bwImg = im2bw(imread(imgPath));
imshow(bwImg);

%% Extract features
structuralElement = strel('square',3);

% Object perimeter
perimeterImg = bwImg - imerode(bwImg, structuralElement); 

% Object area
filledImg = imfill(perimeterImg, 'holes');

% Convex area
convexHullImg = bwconvhull( filledImg );

% Convex perimeter
convexPerimeterImg = convexHullImg - imerode(convexHullImg,structuralElement);

%% Draw images

% Perimeter
h_fig1 = figure(1);
clf(h_fig1);
imshow(perimeterImg);

% Hand and convex hull perimeter
h_fig2 = figure(2); 
clf(h_fig2);
imshow(bwImg);
plot(X,Y,'r')

%% 
compositeImg = imfuse(bwImg, convexPerimeterImg);
compositeImg = im2bw(sum(compositeImg,3));

imshow(compositeImg)