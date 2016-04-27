function handArea = FindHandInImage(jpgImage)
% Finds the hand in a jpeg image using the features 
% extracted by GetFeatures.m. The matching of features is
% currently carried out by using a euclidean distance metric in
% the feature space.
%
% input: a .jpeg image.
%
% output: rectangular area (x,y,w,h) where the hand resides.
%
% TODO: Improve distance metric. Use a good version of SkinColor2Binary.m
%

% Adding working directories
%addpath('./../../images/images-04-26');
%addpath('./../../lib/analysis_modules');
%addpath('./../../images');

%%%%%%%%% Extracting features from known hand %%%%%%%%%
templateImage = imread('image1.jpg');
templateImage = SkinColor2Binary(templateImage);
templateImage = templateImage([350,200,300,300]);
templateFeatures = GetFeatures(templateImage);


%%%%%%%%% Extracting features from jpgImage %%%%%%%%%

% Converting the image to binary regions.
binaryImage = SkinColor2Binary(jpgImage);

% Extracting the binary regions from binaryImage.
binaryRegions = regionprops(binaryImage);

% Sorting the extracted binary regions with largest area first.
[~,areaIdx] = sort(-[binaryRegions.Area]);
lastIdx = min(10,length(areaIdx));
bBox = cat(1,binaryRegions.BoundingBox);

% The first index corresponds to the index in the bounding box
% for the extracted region. The second corresponds to a matchFactor. The
% value of the matchFactor is preferebly small for a good match.
bestMatchedArea = [1,inf];

% Comparing feature matched for the different regions and storing the
% best matched region in bestMatchedArea.
for i = 1:lastIdx
  
  % Converting the bounding box 
  areaVec = round([bBox(areaIdx(i),1), bBox(areaIdx(i),1) + bBox(areaIdx(i),3),...
            bBox(areaIdx(i),2), bBox(areaIdx(i),2) + bBox(areaIdx(i),4)]);
  newFeatures = GetFeatures(binaryImage(areaVec));
  
  % The distance metric for the feature vectors.
  matchFactor = sum(abs(newFeatures - templateFeatures));
  
  % Update the most likely area that might contain a hand.
  if(matchFactor < bestMatchedArea(2))
    bestMatchedArea = [i, matchFactor];
  end

end

handArea = bBox(bestMatchedArea(1),:);

end
