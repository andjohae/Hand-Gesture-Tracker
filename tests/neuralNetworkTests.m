clc;
clear all;

% Parameters
hiddenLayerSize = [10, 5];

% Load data [features, key]
load('./images/feature-eval-images/feature_values.mat');

inputs = features';

% Create target matrix (required for patternnet training)
targets = zeros(2,length(key));
targets(1,logical(key)) = 1;
targets(2,~logical(key)) = 1;

% Create pattern recognition network with Scaled Conjugate Gradient method
net = patternnet(hiddenLayerSize,'trainscg');

% Set up data fractions for Training, Validation, Testing
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;

% Train network
[net, tr] = train(net, inputs, targets);

% Test network
outputs = net(inputs);
errors = gsubtract(targets, outputs);
performance = perform(net, targets, outputs);

% Print performance
fprintf('Network performance: %.5f\n', performance);

%% Plot performance and confusion
plotperform(tr);
plotconfusion(targets, outputs);
%figure, plottrainstate(tr)
%figure, ploterrhist(error)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)
shg

%% Save network
networkPath = './lib/classification/NeuralNetwork.m';
genFunction(net, networkPath, 'MatrixOnly', 'yes');

% NOTE: To use NeuralNetwork.m for hand classification:
% class = vec2ind(output) - 1;
% logical(class) may be necessary