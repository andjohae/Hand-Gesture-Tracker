%% Backward selection
clc;
clear all;
addpath(genpath('./lib/'));

% Parameters
IMAGE_DIR_PATH = '../images/feature-eval-images/';
FEATURE_NAMES = {'Formfactor','Elongatedness','Convexity','Solidity',...
            'Area moment 1','Area moment 2','Area moment 3',...
            'Area moment 4','Area moment 5','Area moment 6'};

% Initialization
nTotalFeatures = size(FEATURE_NAMES,2);
bestErrorRates = zeros(nTotalFeatures,1);
selectedFeatures = zeros(nTotalFeatures,1);
availableFeatures = 1:nTotalFeatures;

% % Read features and key table from images
% [features, key] = ReadImageFeatures(IMAGE_DIR_PATH, nTotalFeatures);

% Load existing feature data: [features, key]
load('./images/feature-eval-images/feature_values.mat');

nCases = size(features,1);

% Calculate error rate for all features used
isWrongClass = ClassifyWithMinMax(features,1:nTotalFeatures) ~= key;
bestErrorRates(nTotalFeatures) = sum(isWrongClass)/nCases;

% Main loop
for iNumFeaturesUsed = nTotalFeatures-1:-1:1
  nAvailableFeatures = length(availableFeatures);
  errorRates = zeros(nAvailableFeatures, 1);
  
  % Loop over removed features
  for iFeature = 1:nAvailableFeatures
    tmpSelected = [availableFeatures(1:iFeature-1), availableFeatures(iFeature+1:end)];
    
%     isWrongClass = ClassifyHands(features(:,tmpSelected),tmpSelected) ~= key;
    isWrongClass = ClassifyWithMinMax(features(:,tmpSelected), tmpSelected) ~= key;
    
    errorRates(iFeature) = sum(isWrongClass);
  end
  errorRates = errorRates./nCases;
  
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
  fprintf('(%d) %s,\n', i, FEATURE_NAMES{selectedFeatures(i)});
end
fprintf('\n');

%% Plot results
h_fig2 = figure(2);
clf(h_fig2);

hold on
%   h_unityLine2 = plot([0,10.5],[1,1],'k-');
  h_backPlot = plot(1:nTotalFeatures, 1-bestErrorRates,'bo-',...
      'MarkerFaceColor',[0 0 1]);
hold off

set(gca,'XTick',1:nTotalFeatures);
axis([0.5 10.5 0.4 1.0]);
box on;
grid on;

% title('Classification rates from backward selection',...
%     'Interpreter','Latex','FontSize',16);
ylabel('Classification rate','Interpreter','Latex','FontSize',14);
xlabel('Number of features used','Interpreter','Latex','FontSize',14);

% Add list of features in order of addition
annotationPosition = [0.6 0.15 0.27 0.47];
annotationStringBack = cell(nTotalFeatures,1);
for i = 1:nTotalFeatures
  annotationStringBack(i) = strcat(sprintf('(%d) ',i),FEATURE_NAMES(selectedFeatures(i)));
end
h_an2 = annotation('textbox', annotationPosition,'BackgroundColor',[1 1 1],...
    'String',annotationStringBack,'Interpreter','Latex','FontSize',12);