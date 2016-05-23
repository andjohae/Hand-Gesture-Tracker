% This file is intended to crop the image in each localization of the hand
% region and use the ComputeCenterOfMass-function to efficiently locate
% the region of interest. 

clf;
addpath(genpath('./lib/'));
addpath(genpath('./images/'));
addpath('./tests/');
currAxes = axes;
movie = 'zVid_2.mov';
vidObj = VideoReader(movie);

% Obtaining the first frame of the movie 
% and detects the most likely region to contain a hand.

currentImage = readFrame(vidObj);
currentBinaryImage = Ycc2Binary(currentImage);% & Ycc2Binary(currentImage);
videoDims = size(currentBinaryImage);

% Extracting regions.

tic
regions = regionprops(currentBinaryImage);
[~, sortedIdxs] = sort(-[regions.Area]);
centroids = cat(1,regions.Centroid);
bBox = cat(1,regions.BoundingBox);
areas = cat(1,regions.Area);
toc

% Finding hand region. (Do not consider small regions Area < 500)
% CURRENTLY NOT CLASSIFYING ANY HAND!
handCenter = [0, 0];
handRegion = [0, 0, 0, 0];
for i = 1:length(areas)
  if(areas(i) >= 500)
    binaryImage = imcrop(currentBinaryImage, bBox(i,:));
    selectedFeatures = [1 2 3 6 7]; % Example
    features = GetFeatures(binaryImage);
    class = ClassifyHands(features(selectedFeatures),selectedFeatures)
    if(class == 1) % If hand is found - save location and break.
      handRegion = bBox(i,:);
      handCenter = centroids(i,:);
      break;
    end
  end
end

% Temporarily choosing the largest region.
handRegion = bBox(sortedIdxs(2),:);
handCenter = centroids(sortedIdxs(2),:);


% Chosing an appropriate cropping box for efficient tracking.
side = min(handRegion(3),handRegion(4));
handRegion(3) = side; handRegion(4) = side;
%binaryImage = imcrop(currentBinaryImage, handRegion);

% Initializing the trajectory tracking.
trajectory = [NaN, NaN; handCenter(1), handCenter(2)];
kalmanTrajectory = [NaN, NaN; handCenter(1), handCenter(2)];

% Assuming that there is no initial motion.
state = [handCenter(1); handCenter(2);0;0];
estimate = state;
P = zeros(4);

while hasFrame(vidObj)  
  
  tic;
  xPrevCenter = handRegion(1) + handRegion(3)/2;
  yPrevCenter = handRegion(2) + handRegion(4)/2;
  currentImage = readFrame(vidObj);
  binaryImage = Ycc2Binary(imcrop(currentImage,handRegion));
  
  center = ComputeCenterOfMass(binaryImage);
  xNewCenter = handRegion(1) + center(1);
  yNewCenter = handRegion(2) + center(2);
  
  state = [xNewCenter; yNewCenter; ...
           xNewCenter - xPrevCenter;yNewCenter - yPrevCenter];
  
  [~, estimate, P] = PredictState(state, estimate, P);
  trajectory = [trajectory; xNewCenter,yNewCenter];
  kalmanTrajectory = [kalmanTrajectory; estimate(1),estimate(2)];
  
  %handRegion(1) = handRegion(1) + xNewCenter - xPrevCenter;
  %handRegion(2) = handRegion(2) + yNewCenter - yPrevCenter;
  
  handRegion(1) = estimate(1) - handRegion(3)/2;
  handRegion(2) = estimate(2) - handRegion(4)/2;
  

  
  image(currentImage);
  hold on;
  plot(xNewCenter,yNewCenter,'r*')
  plot(estimate(1),estimate(2),'go')
  rectangle('position', handRegion);
  legend('Normal','Adaptive Kalman');
  t = toc;
  currAxes.Visible = 'off';
  pause(max(1/vidObj.FrameRate-t,0));
  drawnow
  shg
  
end

%%

clf;
vidObj = VideoReader(movie);
currentImage = readFrame(vidObj);
imshow(currentImage);
hold on 
plot(trajectory(:,1),trajectory(:,2),'r')
plot(kalmanTrajectory(:,1),kalmanTrajectory(:,2),'g')
leg = legend('Measured trajectory','Kalman trajectory')
set(leg,'interpreter', 'latex')
shg

%%