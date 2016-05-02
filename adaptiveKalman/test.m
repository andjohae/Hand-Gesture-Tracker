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

clf; clear all
currAxes = axes;
vidObj = VideoReader('testMov1.mov');

while hasFrame(vidObj)
  
  tic;
  currentImage = readFrame(vidObj);
  binaryImage = ExtractSkinColor(currentImage);
  regions = regionprops(binaryImage);
  [~, sortedIdxs] = sort(-[regions.Area]);
  centroids = cat(1,regions.Centroid);
  bBox = cat(1,regions.BoundingBox);
  x = centroids(sortedIdxs(1),1);
  y = centroids(sortedIdxs(1),2);  
 
  image(currentImage-0.004);
  hold on;
  plot(x,y,'r*')

  currAxes.Visible = 'off';
  %pause(1/vidObj.FrameRate);
  pause(0.001);
  shg
  toc

end

%% Using motions....
while hasFrame(vidObj)
  
  binaryPrevImage = ExtractSkinColor(prevImage);
  curImage = readFrame(vidObj);
  binaryCurImage = ExtractSkinColor(curImage);
  motionImage = ExtractMotion(prevImage, curImage);
  combinedImage = (binaryCurImage & motionImage) | (binaryPrevImage & motionImage);
  [x,y,w,h] = ComputeRegionOfInterest(combinedImage);
  imshow(curImage);
  hold on;

  if(x ~= -1)
    rectangle('Position',[x,y,w,h]);
  end

  currAxes.Visible = 'off';
  pause(1/vidObj.FrameRate);
  prevImage = curImage;
  shg

end

%%

clf
addpath('./../images/sequenceImages-05-02/')
addpath('./../images/')
I1 = imread('im2.jpg');
I2 = imread('im3.jpg');
binarySkin = ExtractSkinColor(I2);
%regions = bwpropfilt(binarySkin,'Area',2) - bwpropfilt(binarySkin,'Area',1);
regions = bwpropfilt(binarySkin,'Perimeter',10);
%imshow(regions);
%rectangle('Position',regions.BoundingBox)
shg
binaryMotion = ExtractMotion(I1,I2);
imshow(binaryMotion & binarySkin)
shg
%combinedImage = (binarySkin & binaryMotion);
%[x,y,w,h] = ComputeRegionOfInterest(combinedImage);
%%
imshow(I2);
hold on
rectangle('Position',[x,y,w,h]);
shg



