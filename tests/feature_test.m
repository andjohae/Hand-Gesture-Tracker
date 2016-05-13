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
imageDirPath = '../images/feature-eval-images/';
selectedFeatures = 1:8;

knownFeatures = GetKnownHandFeatures(imageDirPath, selectedFeatures);

featureMean = mean(knownFeatures);
featureStd  = std(knownFeatures);

fprintf('Mean of features:\n');
fprintf('%.9f\n', featureMean);
fprintf('\n');
fprintf('Standard deviation of features:\n');
fprintf('%.9f\n', featureStd);

% fprintf('Formfactor \tElongatedness \tConvexity \tSolidity\n');
% fprintf('---------------------------------------------------------\n');
% fprintf('%.6f \t%.6f \t%.6f \t%.6f\n', knownFeatures');
% fprintf('---------------------------------------------------------\n');
% fprintf('%.6f \t%.6f \t%.6f \t%.6f | mean\n', featureMean);
% fprintf('%.6f \t%.6f \t%.6f \t%.6f | std \n', featureStd);

%% Test feature combinations -- all possible
clc

% Parameters
imageDirPath = '../images/feature-eval-images/';
features = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Area moment 1','Area moment 2','Area moment 3','Area moment 4'};
nUsedFeatures = 4;

% Initialization

nTotalFeatures = size(features,2);
selectedFeatures = combnk(1:nTotalFeatures, nUsedFeatures);
nCombinations = size(selectedFeatures,1)
errorRates = zeros(nCombinations,1);

% Loop over feature combinations
for iComb = 1:nCombinations
  errorRates(iComb) = EvaluateFeatureChoices(imageDirPath, selectedFeatures(iComb,:));
end
% disp('Error rates:');
% disp(errorRates);

% Find and print best feature combination
[~, iBestFeatures] =  min(errorRates);
bestFeatures = features(selectedFeatures(iBestFeatures,:));
fprintf('Best features: ');
for i = 1:length(bestFeatures)
  fprintf('%s, ', bestFeatures{i});
end
fprintf('\n');

