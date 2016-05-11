%% Backward selection
clc;
clear all;
addpath('../lib/feature_extraction/');

% Parameters
imageDirPath = '../images/feature-eval-images/';
features = {'Formfactor','Elongatedness','Convexity','Solidity'};

% Initialization
nTotalFeatures = size(features,2);
bestErrorRates = zeros(nTotalFeatures,1);
removedFeatures = [];
availableFeatures = 1:nTotalFeatures;

for iNumFeaturesUsed = nTotalFeatures:-1:1
  fprintf('Number of features used: %d\n', iNumFeaturesUsed);
  
  nAvailableFeatures = length(availableFeatures);
  errorRates = zeros(nAvailableFeatures, 1);
  
  % Loop over additional features
  for iFeature = 1:nAvailableFeatures
    tmpSelected = [removedFeatures, availableFeatures(iFeature)]; 
    [tmpError, ~] = EvaluateFeatureChoices(imageDirPath, tmpSelected);
    errorRates(iFeature) = tmpError;
  end
  
  % Store best additional feature
  [tmpErrorRate, iWorstFeature] =  max(errorRates);
  removedFeatures = [removedFeatures, availableFeatures(iWorstFeature)];
  bestErrorRates(iNumFeaturesUsed) = tmpErrorRate; 
  availableFeatures(iWorstFeature) = [];
end

% Print results
fprintf('Backward selected features:\n');
for i = nTotalFeatures:-1:1
  fprintf('%s, ', features{removedFeatures(i)});
end
fprintf('\n');

% Plot results
h_fig = figure(2);
clf(h_fig);
plot(1:nTotalFeatures, 1-bestErrorRates,'b.-');
axis([0.5 4.8 0.9 1]);
set(gca,'XTick',1:4);
title('Classification rates from backward selection',...
    'Interpreter','Latex','FontSize',16);
ylabel('Classification rate','Interpreter','Latex','FontSize',14);
xlabel('Number of features used','Interpreter','Latex','FontSize',14);

text(0.9:4, 1-bestErrorRates + 0.007, features(removedFeatures),...
    'Interpreter','Latex','FontSize',12);
