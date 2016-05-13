% Testing with the adaptive kalman filter from "dendära artikeln".
clf; clear all
addpath('./../lib/adaptiveKalman/')
currAxes = axes;
vidObj = VideoReader('testMov1.mov');
trajectory = [NaN, NaN];
trajectory = [trajectory; 758.4676,369.6482];
kalmanTrajectory = [NaN, NaN];
kalmanTrajectory = [kalmanTrajectory; 758.4676,369.6482];

x = 758.4676;
y = 369.6482;
oldState = [758.4676;369.6482;0;0];
oldEst = oldState;
oldP = zeros(4);

while hasFrame(vidObj)
  
  %tic;
  currentImage = readFrame(vidObj);
  binaryImage = ExtractSkinColor(currentImage);
  regions = regionprops(binaryImage);
  [~, sortedIdxs] = sort(-[regions.Area]);
  centroids = cat(1,regions.Centroid);
  bBox = cat(1,regions.BoundingBox);
  %oldState = [x;y;oldState(1)-x;oldState(2)-y];
  x = centroids(sortedIdxs(1),1);
  y = centroids(sortedIdxs(1),2);
  oldState = [x;y;oldState(1)-x;oldState(2)-y];
  [~, oldEst, oldP] = PredictState(oldState, oldEst, oldP);
  [oldEst oldState];
  trajectory = [trajectory; x,y];
  kalmanTrajectory = [kalmanTrajectory; oldEst(1),oldEst(2)];
 
  image(binaryImage);
  hold on;
  plot(x,y,'r*')
  plot(oldEst(1),oldEst(2),'go')
  legend('Normal','Adaptive Kalman');

  currAxes.Visible = 'off';
  pause(1/vidObj.FrameRate);
  shg
  %toc

end

%% Plotting the trajectories

clf;
subplot(1,2,1)
xVecT = linspace(0,1,length(trajectory(:,1)));
plot(xVecT,trajectory(:,2))
subplot(1,2,2)
xVecKT = linspace(0,1,length(kalmanTrajectory(:,1)));
plot(xVecKT,kalmanTrajectory(:,2))
shg



