clc;
clear all;

% Add file paths
addpath( genpath('../') );

% Parameters
imgDirPath = '../images/feature-eval-images/';
nTotalFeatures = 10;

% Get features from files
[features, key] = ReadImageFeatures(imgDirPath, nTotalFeatures);
key = logical(key);

%% Plot all features
figure(1);
h_gplot = gplotmatrix(features(:,1:end), features(:,1:end), key);

%% Plot separate features

% Choose features to plot
f1 = 3;
f2 = 5;

FEATURE_NAMES = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Moment invariant 1','Moment invariant 2','Moment invariant 3',...
            'Moment invariant 4','Moment invariant 5','Moment invariant 6'};

groups = cell(length(key),1);
groups(key) = {'Hands'};
groups(~key) = {'Non-hands'};

h_fig = figure(2);
clf(h_fig);
  
gscatter(features(:,f1),features(:,f2),groups,'br','xo',6,'on',...
    FEATURE_NAMES{f1},FEATURE_NAMES{f2}); 
