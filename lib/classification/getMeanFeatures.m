%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find characteristic feature values for hands %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
clc;
clear all;
addpath('../lib/feature_extraction/');

% Parameters
IMAGE_DIR_PATH = '../images/feature-eval-images/';
selectedFeatures = 1:10;

knownFeatures = GetKnownHandFeatures(IMAGE_DIR_PATH, selectedFeatures);

featureMean = mean(knownFeatures);
featureStd  = std(knownFeatures);

fprintf('Mean of features:\n');
fprintf('%.9f\n', featureMean);
fprintf('\n');
fprintf('Standard deviation of features:\n');
fprintf('%.9f\n', featureStd);
  