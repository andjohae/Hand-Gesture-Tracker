%% Initialize
clc;
clear all;

% Add file paths
addpath( genpath('./') );

% Parameters
IMAGE_DIR_PATH = './images/feature-eval-images/';
nTotalFeatures = 10;

%% Get features from images
% [features, key] = ReadImageFeatures(imgDirPath, nTotalFeatures);

%% Get features from saved data
load('./images/feature-eval-images/feature_values.mat');

%% Plot all features
figure(1);
h_gplot = gplotmatrix(features(:,1:4), features(:,1:4), key);

%% Plot separate features

% Choose features to plot
f1 = 1;
f2 = 4;

FEATURE_NAMES = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Moment invariant 1','Moment invariant 2','Moment invariant 3',...
            'Moment invariant 4','Moment invariant 5','Moment invariant 6'};

groups = cell(length(key),1);
groups(logical(key)) = {'Hands'};
groups(~logical(key)) = {'Non-hands'};

h_fig = figure(2);
clf(h_fig);
  
gscatter(features(:,f1),features(:,f2),groups,'br','xo',6,'on',...
    FEATURE_NAMES{f1},FEATURE_NAMES{f2}); 
