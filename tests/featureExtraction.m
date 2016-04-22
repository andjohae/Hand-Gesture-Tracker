%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Tests for feature extraction %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathParts = strsplit(pwd,'/');
isCorrectPWD = strcmp(pathParts(end), 'tests');
if ~isCorrectPWD
  disp('Wrong working directory!');
  break;
end

% Initialization
clear all;
addpath('../images');
addpath('../lib/analysis_modules/');

% Read images
img = imread('image1.jpg');
figure(1);
imshow(img);

%% Create bw image from thresholding on R-channel
bw_img = RedChannel2Binary(img);
imshow(bw_img);

%% Perimeter
