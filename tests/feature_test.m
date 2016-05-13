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

% fprintf('Formfactor \tElongatedness \tConvexity \tSolidity\n');
% fprintf('---------------------------------------------------------\n');
% fprintf('%.6f \t%.6f \t%.6f \t%.6f\n', knownFeatures');
% fprintf('---------------------------------------------------------\n');
% fprintf('%.6f \t%.6f \t%.6f \t%.6f | mean\n', featureMean);
% fprintf('%.6f \t%.6f \t%.6f \t%.6f | std \n', featureStd);

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

%% Test feature combinations -- all possible
% --- NO LONGER USED ---

% clc
% 
% % Parameters
% imageDirPath = '../images/feature-eval-images/';
% features = {'Formfactor','Elongatedness','Convexity','Solidity',...
%             'Area moment 1','Area moment 2','Area moment 3',...
%             'Area moment 4','Area moment 5','Area moment 6'};
% % nUsedFeatures = 6;
% 
% % Initialization
% nTotalFeatures = size(features,2);
% bestErrorRates = zeros(nTotalFeatures,1);
% 
% % Loop over all combinations
% for nUsedFeatures = 1:nTotalFeatures
%   fprintf('Number of features used: %d\n', nUsedFeatures);
%   
%   selectedFeatures = combnk(1:nTotalFeatures, nUsedFeatures);
%   nCombinations = size(selectedFeatures,1)
%   errorRates = zeros(nCombinations,1);
% 
%   % Loop over feature combinations
%   for iComb = 1:nCombinations
%     errorRates(iComb) = EvaluateFeatureChoices(imageDirPath, selectedFeatures(iComb,:));
%   end
%   % disp('Error rates:');
%   % disp(errorRates);
% 
%   % Find and print best feature combination
%   [tmpBestError, iBestFeatures] =  min(errorRates);
%   bestFeatures = features(selectedFeatures(iBestFeatures,:));
%   bestErrorRates(nUsedFeatures) = tmpBestError;
%   
%   fprintf('Best features:\n');
%   for i = 1:length(bestFeatures)
%     fprintf('%s\n', bestFeatures{i});
%   end
%   fprintf('\n');
% end
% %% Total number of combinations
% total = 0;
% for i = 1:nTotalFeatures
%   total = total + size(combnk(1:nTotalFeatures,i),1);
% end
% fprintf('Total number of combinations: %d\n',total);