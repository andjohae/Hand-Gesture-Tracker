%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Test features %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
clc;
clear all;
addpath('../lib/feature_extraction/');

%% Find mean feature values of known hands 

% Parameters
imageDirPath = '../images/feature-eval-images/';
selectedFeatures = 1:4;

[~, features] = EvaluateFeatureChoices(imageDirPath, selectedFeatures);

featureMean = mean(features);
featureStd  = std(features);

fprintf('Form factor \tElongatedness \tConvexity \tSolidity\n');
fprintf('---------------------------------------------------------\n');
fprintf('%.6f \t%.6f \t%.6f \t%.6f\n', features');
fprintf('---------------------------------------------------------\n');
fprintf('%.6f \t%.6f \t%.6f \t%.6f | mean\n', featureMean);
fprintf('%.6f \t%.6f \t%.6f \t%.6f | std \n', featureStd);

%% Test feature combinations

[errorRate, ~] = EvaluateFeatureChoices(imageDirPath, selectedFeatures);