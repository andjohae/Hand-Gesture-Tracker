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

>> help genFunction
genFunction - Generate MATLAB function for simulating neural network

    This MATLAB function generates a complete stand-alone MATLAB function for
    simulating a neural network including all settings, weight and bias values,
    module functions, and calculations in one file.

    genFunction(net,pathname)
    genFunction(___,'MatrixOnly','yes')
    genFunction(___,'ShowLinks','no')

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

%% Save network
networkPath = './lib/classification/NeuralNetwork.m';
genFunction(net, networkPath, 'MatrixOnly', 'yes');

% NOTE: To use NeuralNetwork.m for hand classification:
% class = vec2ind(output) - 1;
% logical(class) may be necessary