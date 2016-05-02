%% Finding a hand in an image.

clf
addpath('./movementLvl3')
addpath('./Hand-Gesture-Tracker/images/images-04-29/')
addpath('./Hand-Gesture-Tracker/images/images-04-26/')

currAxes = axes;
vidObj = VideoReader('testMov1.mov');

prevImage = readFrame(vidObj);

while hasFrame(vidObj)
  
  % Read Every fifth frame
  for i = 1:5
    if(hasFrame(vidObj))
      readFrame(vidObj);
    else 
      break;
    end
  end
  
  
  if(hasFrame(vidObj))
    binaryPrevImage = ExtractSkinColor(prevImage);
    curImage = readFrame(vidObj);
    binaryCurImage = ExtractSkinColor(curImage);
    motionImage = ExtractMotion(prevImage, curImage);
    combinedImage = (binaryCurImage & motionImage) | (binaryPrevImage & motionImage);
    %regionOfInterest = 
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



