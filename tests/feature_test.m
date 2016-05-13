%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Test features %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
clc;
clear all;
addpath('../lib/feature_extraction/');

%% Find mean feature values of known hands 
clc
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


%% Find optimal feature combination
clc
IMAGE_DIR_PATH = '../images/feature-eval-images/';
FEATURE_NAMES = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Area moment 1','Area moment 2','Area moment 3',...
            'Area moment 4','Area moment 5','Area moment 6'};   
       
[bestFeatures, errorRates] = FindBestFeatures(IMAGE_DIR_PATH, length(FEATURE_NAMES));

[minErrorRate, iBest] = min(errorRates);

fprintf('Best classification rate: %.3f\n', 1-minErrorRate);
fprintf('obtained for feature vector:\n');
fprintf('%s\n', FEATURE_NAMES{bestFeatures{iBest}})

for i = 1:length(FEATURE_NAMES)
fprintf('\nNumber of features: %d\n',i);
fprintf('%s\n', FEATURE_NAMES{bestFeatures{i}});
end