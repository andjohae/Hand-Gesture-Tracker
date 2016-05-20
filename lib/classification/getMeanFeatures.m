%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find characteristic feature values for hands %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
clc;
clear all;
addpath( genpath('../lib/') );

% Parameters
IMAGE_DIR_PATH = '../images/feature-eval-images/';
nTotalFeatures = 10;

% knownFeatures = GetKnownHandFeatures(IMAGE_DIR_PATH, selectedFeatures);
[features, key] = ReadImageFeatures(IMAGE_DIR_PATH, nTotalFeatures);
knownFeatures = features(logical(key),:);

featureMean = mean(knownFeatures);
featureStd  = std(knownFeatures);

fprintf('Mean of features:\n');
fprintf('%.9f\n', featureMean);
fprintf('\n');
fprintf('Standard deviation of features:\n');
fprintf('%.9f\n', featureStd);
  