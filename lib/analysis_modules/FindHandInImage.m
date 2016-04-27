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
  templateImage = imcrop(templateImage,[370 220 350 250]);
  templateFeatures = GetFeatures(templateImage);
  imshow(templateImage); shg

  %%%%%%%%% Extracting features from jpgImage %%%%%%%%%

  % Converting the image to binary regions.
  binaryImage = SkinColor2Binary(jpgImage);
  figure(4)
  imshow(binaryImage);
  shg
  
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
    newFeatures = GetFeatures(imcrop(binaryImage,bBox(areaIdx(i),:)));
    % The distance metric for the feature vectors.
    matchFactor = sum(abs(newFeatures - templateFeatures));

    % Update the most likely area that might contain a hand.
    if(matchFactor < bestMatchedArea(2))
      bestMatchedArea = [i, matchFactor];
      matchFactor
    end

  end

  handArea = bBox(bestMatchedArea(1),:);

end
