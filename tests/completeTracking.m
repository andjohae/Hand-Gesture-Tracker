% Complete tracking program for tracking hand motions. The program 
% finds a hand in a video specified by the user by the movie-variable.
% When the hand region is found (or set to the largest region if no
% hand is found) the tracking begins. For each frame of the video a 
% classification also occurs and a rectangle specifying the hand region 
% is superimposed in the image indicating wheter the region contains a hand
% (green) or not (red).
%
% There are three different classification methods currently specified in
% the code. Depending on which of them to use the user may comment and
% uncomment sections of the code (see comments in the code).

clf; clear all;
addpath(genpath('./lib/'));
addpath(genpath('./images/'));
addpath('./tests/');
currAxes = axes;
movie = 'whiteBackVid_1.mov';
vidObj = VideoReader(movie);

% Reads first frame of the video object and processes the image 
% to make skin regions white and all other regions black (optimally)
currentImage = readFrame(vidObj);
currentBinaryImage = Ycc2Binary(currentImage);
currentBinaryImage = imopen(currentBinaryImage, strel('disk',5));
videoDims = size(currentBinaryImage);

% Extracting white regions.
regions = regionprops(currentBinaryImage);
[~, sortedIdxs] = sort(-[regions.Area]);
centroids = cat(1,regions.Centroid);
bBox = cat(1,regions.BoundingBox);
areas = cat(1,regions.Area);


load('./images/feature-eval-images/feature_values.mat');
handCenter = [0, 0];
handRegion = [0, 0, 0, 0];

%############ "REGUALR" CLASSIFICATION #############
% selectedFeatures = [1 2 3 4 5 6 7 8 9 10]; % Example
% for i = 1:length(areas)
%   if(areas(i) >= 500)
%     binaryImage = imcrop(currentBinaryImage, bBox(i,:));
%     features = GetFeatures(binaryImage);
%     class = ClassifyHands(features(selectedFeatures),selectedFeatures)
%     if(class == 1) % If hand is found - save location and break.
%       handRegion = bBox(i,:);
%       handCenter = centroids(i,:);
%       break;
%     end
%   end
% end
%##################################################


%############ MIN_MAX CLASSIFICATION ##############
% selectedFeatures = [1 2 3 4 5 6 7 8 9 10]; % Example
% for i = 1:length(areas)
%   if(areas(i) >= 500)
%     binaryImage = imcrop(currentBinaryImage, bBox(i,:));
%     features = GetFeatures(binaryImage);
%     class = ClassifyWithMinMax(features(selectedFeatures),selectedFeatures)
%     if(class == 1) % If hand is found - save location and break.
%       handRegion = bBox(i,:);
%       handCenter = centroids(i,:);
%       break;
%     end
%   end
% end
%##################################################


%################## SVM classification ##################
% model = fitcsvm(features,key);
% for i = 1:length(areas)
%   if(areas(i) >= 500)
%     binaryImage = imcrop(currentBinaryImage, bBox(i,:));
%     features = GetFeatures(binaryImage);
%     class = predict(model,features);
%     if(class == 1) % If hand is found - save location and break.
%       handRegion = bBox(i,:);
%       handCenter = centroids(i,:)
%       break;
%     end
%   end
% end
%########################################################


%################ NN classification ###############
class = [0;0;0];
for i = 1:length(areas)
  if(areas(i) >= 500)
    binaryImage = imcrop(currentBinaryImage, bBox(i,:));
    features = GetFeatures(binaryImage);
    class = [class,[NeuralNetwork(features');i]];
  end
end
[~,tmpIndex] = max(class(1,:));
if(tmpIndex ~= 1)
  handRegion = bBox(class(3,tmpIndex),:);
  handCenter = centroids(class(3,tmpIndex),:);
end
%##################################################


% If the classification didn't manage to find a hand we choose
% the largest blob as the hand region.
if(handCenter(1) == 0 && handCenter(2) == 0)
  handRegion = bBox(sortedIdxs(1),:);
  handCenter = centroids(sortedIdxs(1),:);
end

% The hand region size is set to be the square with side equal to the
% largest side of the regionprops-rectangle covering the hand.
side = max(handRegion(3),handRegion(4));
handRegion(3) = side; handRegion(4) = side;

% Initializing the trajectory to start and the hand center and 
% defining the matrix P for the Kalman filter.
trajectory = [NaN, NaN; handCenter(1), handCenter(2)];
kalmanTrajectory = [NaN, NaN; handCenter(1), handCenter(2)];
state = [handCenter(1); handCenter(2);0;0];
estimate = state;
P = zeros(4);

%% Optional pre-read
images = {};
newObj = vidObj;
iter = 1;
while(hasFrame(newObj))
  images{iter} = readFrame(newObj);
  iter = iter+1
end

%%
clf
iter = 1;
for i = 1:length(images)
%while hasFrame(vidObj)  

  tic
  xPrevCenter = handRegion(1) + handRegion(3)/2;
  yPrevCenter = handRegion(2) + handRegion(4)/2;
  %currentImage = readFrame(vidObj);
  currentImage = images{iter};
  iter = iter+1;
  
  
  binaryImage = Ycc2Binary(imcrop(currentImage,handRegion));
  binaryImage = imopen(binaryImage, strel('disk',5));
  center = ComputeCenterOfMass(binaryImage);
  xNewCenter = handRegion(1) + center(1);
  yNewCenter = handRegion(2) + center(2);
  state = [xNewCenter; yNewCenter; ...
           xNewCenter - xPrevCenter;yNewCenter - yPrevCenter];
  
  [~, estimate, P] = PredictState(state, estimate, P);
  trajectory = [trajectory; xNewCenter,yNewCenter];
  kalmanTrajectory = [kalmanTrajectory; estimate(1),estimate(2)];
  
  handRegion(1) = estimate(1) - handRegion(3)/2;
  handRegion(2) = estimate(2) - handRegion(4)/2;
  
  
  %############### CHOOSE CLASSIFICATION METHOD ##############
  % Extracing features and classifying image
  regionFeatures = GetFeatures(binaryImage); 
  % class = predict(model,regionFeatures); % SVM-classification
  % MIN-MAX classification (below)..
  %class = ClassifyWithMinMax(regionFeatures(selectedFeatures),selectedFeatures);
  % Regular classification below..
  %class = ClassifyHands(regionFeatures(selectedFeatures),selectedFeatures);
  [~,class] = max(NeuralNetwork(regionFeatures')); % NN-classification
  %############################################################
  toc
  % Plotting the image together with hand region colored according to 
  % classification results.
  myColor = 'r';
  if(class == 1)
    myColor = 'g';
  end
  
  image(currentImage);
  
  hold on;
  plot(xNewCenter,yNewCenter,'r*')
  plot(estimate(1),estimate(2),'go')
  rectangle('position', handRegion,'edgecolor',myColor);
  legend('Normal','Adaptive Kalman');
  
  %currAxes.Visible = 'off';
  %display('1')
  drawnow
  shg
  
end

%% Plotting the trajectories of the movements saved by previous script.

clf;
vidObj = VideoReader(movie);
currentImage = readFrame(vidObj);
imshow(currentImage);
hold on 
plot(trajectory(:,1),trajectory(:,2),'r')
plot(kalmanTrajectory(:,1),kalmanTrajectory(:,2),'g')
leg = legend('Measured trajectory','Kalman trajectory');
set(leg,'interpreter', 'latex')
shg
