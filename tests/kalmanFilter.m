% Testing with the adaptive kalman filter from "dendära artikeln".
clf; clear all
addpath('./../lib/adaptiveKalman/')
currAxes = axes;
vidObj = VideoReader('testMov1.mov');
trajectory = [NaN, NaN];
kalmanTrajectory = [NaN, NaN];
oldState = [758.4676;369.6482;0;0];
oldEst = oldState;
oldP = eye(4);

while hasFrame(vidObj)
  
  %tic;
  currentImage = readFrame(vidObj);
  binaryImage = ExtractSkinColor(currentImage);
  regions = regionprops(binaryImage);
  [~, sortedIdxs] = sort(-[regions.Area]);
  centroids = cat(1,regions.Centroid);
  bBox = cat(1,regions.BoundingBox);
  x = centroids(sortedIdxs(1),1);
  y = centroids(sortedIdxs(1),2);
  oldState = [x;y;oldState(3);oldState(4)];
  [oldState, oldEst, oldP] = PredictState(oldState, oldEst, oldP);
  oldEst;
  [x,y];
  trajectory = [trajectory; x,y];
  kalmanTrajectory = [kalmanTrajectory; oldEst(1),oldEst(2)];
 
  image(currentImage-0.004);
  hold on;
  plot(x,y,'r*')
  plot(oldEst(1),oldEst(2),'go')
  legend('Normal','Adaptive Kalman');

  currAxes.Visible = 'off';
  pause(1/vidObj.FrameRate);
  shg
  %toc

end