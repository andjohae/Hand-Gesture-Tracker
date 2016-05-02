%% Finding a hand in an image.

clf
addpath('./movementLvl3')
addpath('./Hand-Gesture-Tracker/images/images-04-29/')
addpath('./Hand-Gesture-Tracker/images/images-04-26/')

currAxes = axes;
vidObj = VideoReader('testMov1.mov');

prevImage = readFrame(vidObj);
centerPoints = [NaN, NaN];

while hasFrame(vidObj)
  binaryPrevImage = ExtractSkinColor(prevImage);
  curImage = readFrame(vidObj);
  binaryCurImage = ExtractSkinColor(curImage);
  motionImage = ExtractMotion(prevImage, curImage);
  combinedImage = (binaryPrevImage & motionImage) | (binaryCurImage & motionImage);
  center = ComputeCenterOfMass(combinedImage);
  imshow(curImage);
  hold on;
  viscircles(center,10);
  currAxes.Visible = 'off';
  pause(1/vidObj.FrameRate);
  prevImage = curImage; 
  centerPoints = [centerPoints; center];
  shg
end
%%
clf;
imshow(prevImage);
hold on
plot(centerPoints(:,1),centerPoints(:,2));
shg

%%
binaryPrevImage = ExtractSkinColor(prevImage);
binaryCurImage = ExtractSkinColor(prevImage);
motionImage = ExtractMotion(prevImage, curImage);
subplot(2,2,1)
imshow(binaryPrevImage);
subplot(2,2,2)
imshow(motionImage);
subplot(2,2,3)
combinedImage = (binaryPrevImage & motionImage);
imshow(combinedImage);
subplot(2,2,4)
center = ComputeCenterOfMass(combinedImage);
imshow(combinedImage);
hold on
viscircles(center,10)

shg