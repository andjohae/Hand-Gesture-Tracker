%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Find best possible feature combination %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
clc;
clear all;
addpath(genpath('./lib/'));

IMAGE_DIR_PATH = '../images/feature-eval-images/';
FEATURE_NAMES = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Area moment 1','Area moment 2','Area moment 3',...
            'Area moment 4','Area moment 5','Area moment 6'}; 
nTotalFeatures = length(FEATURE_NAMES);
minErrorRates = zeros(nTotalFeatures,1);
bestFeatures = cell(nTotalFeatures,1);          

% % Read features and key table from images
% [features, key] = ReadImageFeatures(IMAGE_DIR_PATH, nTotalFeatures);

% Load existing feature data: [features, key]
load('./images/feature-eval-images/feature_values.mat');

% Loop over feature combinations
for iNumUsedFeatures = 1:nTotalFeatures
  featureCombinations = combnk(1:nTotalFeatures, iNumUsedFeatures);
  nCombinations = size(featureCombinations,1);
  errorRates = zeros(nCombinations,1);
  
  for iComb = 1:nCombinations
%     isWrongClass = ClassifyHands(features(:,featureCombinations(iComb)),...
%       featureCombinations(iComb)) ~= key;
    isWrongClass = ClassifyWithMinMax(features(:,featureCombinations(iComb)),...
      featureCombinations(iComb)) ~= key;
  end
  
  % Find and store best error rate and feature combination
  [tmpBestError, iBestError] = min(errorRates);
  minErrorRates(iNumUsedFeatures) = tmpBestError;
  bestFeatures{iNumUsedFeatures} = featureCombinations(iBestError,:);
end
 
%% Print results
[minErrorRate, iBest] = min(errorRates);

fprintf('Best classification rate: %.3f\n', 1-minErrorRate);
fprintf('obtained for feature vector:\n');
fprintf('%s\n', FEATURE_NAMES{bestFeatures{iBest}})

for i = 1:length(FEATURE_NAMES)
fprintf('\nNumber of features: %d\n',i);
fprintf('%s\n', FEATURE_NAMES{bestFeatures{i}});
end