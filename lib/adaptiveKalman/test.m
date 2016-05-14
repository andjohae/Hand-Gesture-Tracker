%% Finding a hand in an image.

clf
currAxes = axes;
vidObj = VideoReader('testMov1.mov');

prevImage = readFrame(vidObj);
newImage = readFrame(vidObj);
binaryNewImage = ExtractSkinColor(newImage);
regions = regionprops(binaryNewImage);
imshow(newImage)
hold on
[~, sortedIdxs] = sort(-[regions.Area]);
centroids = cat(1,regions.Centroid);
bBox = cat(1,regions.BoundingBox);
x = centroids(sortedIdxs(1),1);
y = centroids(sortedIdxs(1),2);
plot(x,y,'r*')
%rectangle('Position',bBox(sortedIdxs(1),:));
%ExtractMotion(prevImage,newImage);
shg

%% Using only regions....

addpath(genpath('./../../images'))
addpath(genpath('./../'))

clf; clear all
currAxes = axes;
vidObj = VideoReader('whiteBackVid_3.mov');
trajectory = [NaN, NaN];
kalmanTrajectory = [NaN, NaN];
oldState = [758.4676;369.6482;0;0];
oldEst = oldState;
oldP = eye(4);% + [0.01 0.1 -0.09 0.03; 0.01 0.1 -0.09 0.03;0.01 0.1 -0.09 0.03;0.01 0.1 -0.09 0.03];

while hasFrame(vidObj)
  
  %tic;
  currentImage = readFrame(vidObj);
  binaryImage = Ycc2Binary(currentImage);
  %binaryImage = ExtractSkinColor(currentImage);
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
 
  imshow(binaryImage);
  hold on;
  plot(x,y,'r*')
  plot(oldEst(1),oldEst(2),'go')

  currAxes.Visible = 'off';
  %pause(1/vidObj.FrameRate);
  pause(0.001);
  shg,
  %toc

end

%%
clf
vidObj = VideoReader('whiteBackVid_3.mov');
currentImage = readFrame(vidObj);
image(currentImage);
hold on
plot(trajectory(2:(end-15),1),trajectory(2:(end-15),2),'r')
plot(kalmanTrajectory(2:(end-15),1),kalmanTrajectory(2:(end-15),2),'g')
shg

%% Using motions....

clf
currAxes = axes;
vidObj = VideoReader('whiteBackVid_1.mov');

prevImage = readFrame(vidObj);
newImage = readFrame(vidObj);
binaryNewImage = ExtractSkinColor(newImage);
regions = regionprops(binaryNewImage);
imshow(newImage)
hold on


while hasFrame(vidObj)
  
  binaryPrevImage = ExtractSkinColor(prevImage);
  curImage = readFrame(vidObj);
  binaryCurImage = Ycc2Binary(curImage);
  motionImage = ExtractMotion(prevImage, curImage);
  combinedImage = (binaryCurImage & motionImage) | (binaryPrevImage & motionImage);
  [x,y,w,h] = ComputeRegionOfInterest(combinedImage);
  imshow(combinedImage);
  hold on;

  if(x ~= -1)
    plot(x+w/2,y+h/2,'r*');
  end

  currAxes.Visible = 'off';
  pause(1/vidObj.FrameRate);
  prevImage = curImage;
  shg

end

%%

clf
addpath('./../images/images-04-29/')
addpath('./../images/sequenceImages-05-02/')
addpath('./../images/')
%I1 = imread('.jpg');
I2 = imread('redBack5.jpg');
binarySkin = ExtractSkinColor(I2);
binarySkin = imfill(binarySkin,'holes');
%regions = bwpropfilt(binarySkin,'Area',2) - bwpropfilt(binarySkin,'Area',1);
imshow(binarySkin);
shg
%regions = bwpropfilt(binarySkin,'Perimeter',10);
%imshow(regions);
%rectangle('Position',regions.BoundingBox)
%shg
%binaryMotion = ExtractMotion(I1,I2);
%imshow(binaryMotion & binarySkin)
%shg
%combinedImage = (binarySkin & binaryMotion);
%[x,y,w,h] = ComputeRegionOfInterest(combinedImage);
%%
imshow(I2);
hold on
rectangle('Position',[x,y,w,h]);
shg



