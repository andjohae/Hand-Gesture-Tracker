%%  Save features to .mat
clc;

% Parameters
IMAGE_DIR_PATH = './../../images/feature-eval-images/';
nTotalFeatures = 10;

% Get features from files
[features, key] = ReadImageFeatures(IMAGE_DIR_PATH, nTotalFeatures);

% Write to file
save('./../../images/feature-eval-images/feature_values.mat','features','key');
display('done!')