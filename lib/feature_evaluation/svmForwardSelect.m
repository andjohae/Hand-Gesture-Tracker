%% Forward selection
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
selectedFeatures = [];
availableFeatures = 1:nTotalFeatures;

% % Read features and key table from images
% [features, key] = ReadImageFeatures(IMAGE_DIR_PATH, nTotalFeatures);

% Load existing feature data: [features, key]
load('./images/feature-eval-images/feature_values.mat');
features = [features(:,1:4),normc(features(:,5:end))];

nCases = size(features,1);

for iNumFeaturesUsed = 1:nTotalFeatures  
  nAvailableFeatures = nTotalFeatures - iNumFeaturesUsed + 1;
  errorRates = zeros(nAvailableFeatures, 1);
  
  % Loop over additional features
  for iFeature = 1:nAvailableFeatures
    tmpSelected = [selectedFeatures, availableFeatures(iFeature)];
    
    nFold = 10;
    idxs = crossvalind('Kfold',size(features,1),nFold);
    cp = classperf(key);
    tmpError = 0;
    for i = 1:10
        test = (idxs == i); train = ~test;
        model = fitcsvm(features(train,tmpSelected),key(train));
        class = predict(model,features(test,tmpSelected));
        classperf(cp,class,test);
        tmpError = tmpError + cp.ErrorRate;
    end
    errorRates(iFeature) = tmpError/nFold;
  end
  display(strcat(num2str(iFeature),' features processed.'));
  % Store best additional feature
  [tmpErrorRate, iBestFeature] =  min(errorRates);
  selectedFeatures = [selectedFeatures, availableFeatures(iBestFeature)];
  bestErrorRates(iNumFeaturesUsed) = tmpErrorRate; 
  availableFeatures(iBestFeature) = [];
end

% Print results
fprintf('\nForward selected features:\n');
for i = 1:nTotalFeatures
  fprintf('(%d) %s\n', i, FEATURE_NAMES{selectedFeatures(i)});
end
fprintf('\n');

%% Plot results
h_fig1 = figure(1);
clf(h_fig1);

hold on
  h_unityLine1 = plot([0,10.5],[1,1],'k-');
  h_forwardPlot = plot(1:nTotalFeatures, 1-bestErrorRates,'ro-',...
      'MarkerFaceColor',[1 0 0]);
hold off

set(gca,'XTick',1:nTotalFeatures);
axis([0.5 10.5 0.5 1.1]);
box on;
grid on;

title('Classification rates from forward selection, SVM',...
    'Interpreter','Latex','FontSize',16);
ylabel('Classification rate','Interpreter','Latex','FontSize',14);
xlabel('Number of features used','Interpreter','Latex','FontSize',14);

% Add list of features in order of addition
annotationPosition = [0.17 0.15 0.27 0.47];
annotationStringForward = cell(nTotalFeatures,1);
for i = 1:nTotalFeatures
  annotationStringForward(i) = strcat(sprintf('(%d) ',i),FEATURE_NAMES(selectedFeatures(i)));
end
h_an1 = annotation('textbox', annotationPosition,'BackgroundColor',[1 1 1],...
    'String',annotationStringForward,'Interpreter','Latex','FontSize',12);
