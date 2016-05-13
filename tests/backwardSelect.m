%% Backward selection
clc;
clear all;
addpath('../lib/feature_extraction/');

% Parameters
imageDirPath = '../images/feature-eval-images/';
features = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Area moment 1','Area moment 2','Area moment 3',...
            'Area moment 4','Area moment 5','Area moment 6'};

% Initialization
nTotalFeatures = size(features,2);
bestErrorRates = zeros(nTotalFeatures,1);
selectedFeatures = zeros(nTotalFeatures,1);
availableFeatures = 1:nTotalFeatures;

% Calculate error rate for all features used
bestErrorRates(nTotalFeatures) = EvaluateFeatureChoices(imageDirPath, availableFeatures);

% Main loop
for iNumFeaturesUsed = nTotalFeatures-1:-1:1
  fprintf('Number of features used: %d\n', iNumFeaturesUsed);
  
  nAvailableFeatures = length(availableFeatures);
  errorRates = zeros(nAvailableFeatures, 1);
  
  % Loop over removed features
  for iFeature = 1:nAvailableFeatures
    tmpSelected = [availableFeatures(1:iFeature-1), availableFeatures(iFeature+1:end)];
    errorRates(iFeature) = EvaluateFeatureChoices(imageDirPath, tmpSelected);
  end
  
  % Remove worst feature and store best error rate
  [~, iWorstFeature] =  max(errorRates);
  selectedFeatures(iNumFeaturesUsed+1) = availableFeatures(iWorstFeature);
  availableFeatures(iWorstFeature) = [];
  bestErrorRates(iNumFeaturesUsed) = min(errorRates); 
end

% Store last remaining feature and calculate its error rate
selectedFeatures(1) = availableFeatures; 

% Print results
fprintf('\n');
fprintf('Backward selected features:\n');
for i = 1:nTotalFeatures
  fprintf('(%d) %s,\n', i, features{selectedFeatures(i)});
end
fprintf('\n');

%% Plot results
h_fig2 = figure(2);
clf(h_fig2);

h_backPlot = plot(1:nTotalFeatures, 1-bestErrorRates,'bo-');

set(gca,'XTick',1:nTotalFeatures);
axis([0.5 10.5 0.75 1.05]);
box on;

title('Classification rates from backward selection',...
    'Interpreter','Latex','FontSize',16);
ylabel('Classification rate','Interpreter','Latex','FontSize',14);
xlabel('Number of features used','Interpreter','Latex','FontSize',14);

% Add list of features in order of addition
annotationStringBack = cell(nTotalFeatures,1);
for i = 1:nTotalFeatures
  annotationStringBack(i) = strcat(sprintf('(%d) ',i),features(selectedFeatures(i)));
end
h_an2 = annotation('textbox', [0.6 0.15 0.27 0.38],'BackgroundColor',[1 1 1],...
    'String',annotationStringBack,'Interpreter','Latex','FontSize',12);