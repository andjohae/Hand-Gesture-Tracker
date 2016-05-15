% This file is intended to crop the image in each localization of the hand
% region and use the ComputeCenterOfMass-function to efficiently locate
% the region of interest. 

clf; clear all
addpath(genpath('./lib/'));
addpath(genpath('./images/'));
addpath('./tests/');
currAxes = axes;
vidObj = VideoReader('whiteBackVid_1.mov');

% Obtaining the first frame of the movie 
% and detects the most likely region to contain a hand.
currentImage = readFrame(vidObj);
currentBinaryImage = Ycc2Binary(currentImage);
videoDims = size(currentBinaryImage);

% Extracting regions.
regions = regionprops(currentBinaryImage);
[~, sortedIdxs] = sort(-[regions.Area]);
centroids = cat(1,regions.Centroid);
bBox = cat(1,regions.BoundingBox);
areas = cat(1,regions.Area);

% Finding hand region. (Do not consider small regions Area < 500)
% CURRENTLY NOT CLASSIFYING ANY HAND!
handCenter = [0, 0];
handRegion = [0,0,0,0];
for i = 1:length(areas)
  if(areas(i) >= 500)
    binaryImage = imcrop(currentBinaryImage, bBox(i,:));
    selectedFeatures = [1 2 3 6 7]; % Example
    features = GetFeatures(binaryImage);
    class = ClassifyHands(features(selectedFeatures),selectedFeatures);
    if(class == 1) % If hand is found - save location and break.
      handRegion = bBox(i,:);
      handCenter = centroids(i,:);
      break;
    end
  end
end

% Temporarily choosing the largest region.
handRegion = bBox(sortedIdxs(1),:);
handCenter = centroids(sortedIdxs(1),:);


% Chosing an appropriate cropping box for efficient tracking.
side = min(handRegion(3),handRegion(4));
handRegion(3) = side; handRegion(4) = side;
binaryImage = imcrop(currentBinaryImage, handRegion);

% Initializing the trajectory tracking.
trajectory = [NaN, NaN; handCenter(1), handCenter(2)];
kalmanTrajectory = [NaN, NaN; handCenter(1), handCenter(2)];

% Assuming that there is no initial motion.
state = [handCenter(1); handCenter(2);0;0];
estimate = state;
P = zeros(4);


imshow(binaryImage)
shg

while hasFrame(vidObj)
  
  %tic;
  center = ComputeCenterOfMass(binaryImage);
  %handRegion = FindBoundingBox(videoDims, handRegion);
  handRegion(1) = handRegion(1) + x-state(1);
  handRegion(2) = handRegion(2) + state(4);
  x = center(1) + handRegion(1); y = center(2) + handRegion(2);
  state = [x; y; x-state(1); y-state(2)];
  
  [~, estimate, P] = PredictState(state, estimate, P);
  trajectory = [trajectory; x,y];
  kalmanTrajectory = [kalmanTrajectory; estimate(1),estimate(2)];
  estimate
  imshow(binaryImage)
  hold on;
  plot(handRegion(3)/2,handRegion(4)/2,'r*');
  %plot(estimate(1)-center(2),estimate(2)-center(1),'go');
%   image(currentImage);
%   hold on;
%   rectangle('position',handRegion);
%   plot(x,y,'r*')
%   plot(estimate(1),estimate(2),'go')
%   legend('Normal','Adaptive Kalman');

  %currAxes.Visible = 'off';
  pause(1/vidObj.FrameRate);
  
  currentImage = readFrame(vidObj);
  %handRegion = FindBoundingBox(videoDims, side, [x;y]);
  %handRegion = [estimate(1)-side/2,estimate(2)-side/2,side,side];
  %handRegion = FindBoundingBox(videoDims, side, estimate(1:2)');
  currentCroppedImage = imcrop(currentImage, handRegion);
  binaryImage = Ycc2Binary(currentCroppedImage);
  binaryImage = bwareaopen(binaryImage, 40);
  shg
  %toc

end