%% Forward selection
clc;
clear all;
addpath('../lib/feature_extraction/');

% Parameters
imageDirPath = '../images/feature-eval-images/';
features = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Area moment 1','Area moment 2','Area moment 3','Area moment 4'};

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
    errorRates(iFeature) = EvaluateFeatureChoices(imageDirPath, tmpSelected);
  end
  
  % Store best additional feature
  [tmpErrorRate, iBestFeature] =  min(errorRates);
  selectedFeatures = [selectedFeatures, availableFeatures(iBestFeature)];
  bestErrorRates(iNumFeaturesUsed) = tmpErrorRate; 
  availableFeatures(iBestFeature) = [];
end

% Print results
fprintf('\n');
fprintf('Forward selected features:\n');
for i = 1:nTotalFeatures
  fprintf('(%d) %s\n', i, features{selectedFeatures(i)});
end
fprintf('\n');

%% Plot results
h_fig1 = figure(1);
clf(h_fig1);
hold on
  h_p1 = plot(1:nTotalFeatures, 1-bestErrorRates,'ro-');
hold off
box on;
set(gca,'XTick',1:nTotalFeatures);
title('Classification rates from forward selection',...
    'Interpreter','Latex','FontSize',16);
ylabel('Classification rate','Interpreter','Latex','FontSize',14);
xlabel('Number of features used','Interpreter','Latex','FontSize',14);
axis([0.5 8.5 0.75 1.1]);

% Add list of features in order of addition
annotationStringForward = cell(nTotalFeatures,1);
for i = 1:nTotalFeatures
  annotationStringForward(i) = strcat(sprintf('(%d) ',i),features(selectedFeatures(i)));
end
h_an1 = annotation('textbox', [0.2 0.17 0.27 0.38],'BackgroundColor',[1 1 1],...
    'String',annotationStringForward,'Interpreter','Latex','FontSize',12);
