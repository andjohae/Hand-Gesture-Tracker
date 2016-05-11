%% Forward selection
clc;
clear all;

% Parameters
imageDirPath = '../images/feature-eval-images/';
features = {'Formfactor','Elongatedness','Convexity','Solidity'};

% Initialization
nTotalFeatures = size(features,2);
bestErrorRates = zeros(nTotalFeatures,1);
selectedFeatures = [];
availableFeatures = 1:nTotalFeatures;

for iNumFeaturesUsed = 1:nTotalFeatures
  fprintf('Number of features used: %d\n', iNumFeaturesUsed);
  
  nAvailableFeatures = nTotalFeatures - iNumFeaturesUsed + 1;
  errorRates = zeros(nAvailableFeatures, 1);
  
  % Loop over additional features
  for iFeature = 1:nAvailableFeatures
    tmpSelected = [selectedFeatures, availableFeatures(iFeature)]; 
    [tmpError, ~] = EvaluateFeatureChoices(imageDirPath, tmpSelected);
    errorRates(iFeature) = tmpError;
  end
  
  % Store best additional feature
  [tmpErrorRate, iBestFeature] =  min(errorRates);
  selectedFeatures = [selectedFeatures, availableFeatures(iBestFeature)];
  bestErrorRates(iNumFeaturesUsed) = tmpErrorRate; 
  availableFeatures(iBestFeature) = [];
end

% Print results
fprintf('Forward selected features:\n');
for i = 1:nTotalFeatures
  fprintf('%s, ', features{selectedFeatures(i)});
end
fprintf('\n');

% Plot results
h_fig = figure(1);
clf(h_fig);
plot(1:nTotalFeatures, 1-bestErrorRates,'r.-');
axis([0.5 4.8 0.9 1]);
set(gca,'XTick',1:4);
title('Classification rates from forward selection',...
    'Interpreter','Latex','FontSize',16);
ylabel('Classification rate','Interpreter','Latex','FontSize',14);
xlabel('Number of features used','Interpreter','Latex','FontSize',14);

text(0.9:4, 1-bestErrorRates + 0.007, features(selectedFeatures),...
    'Interpreter','Latex','FontSize',12);
