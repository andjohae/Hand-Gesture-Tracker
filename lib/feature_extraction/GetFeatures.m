function features = GetFeatures(binaryImg)
% GetFeatures - Extract features from an object in a binary image.
%
% features = GetFeatures(binaryImg)
%
% binaryImg - Assumed to be a binary image where a single object is represented
% by 1's and and 0's represent the background.
%
% Features: Form factor   = Area / Perimeter^2
%           Elongatedness = Area / Thickness^2
%           Convexity     = Convex perimeter / Perimeter
%           Solidity      = Area / Convex area
%
%           Moment invariant 1 to 6 (see GetMoments.m)
%
% Note that all features invariant to translation, scaling, rotation and
% mirroring.
  
  %%%%% Initialization %%%%%
  structuralElement = strel('square',3);
  
  % Check image validity
  if ~islogical(binaryImg)
    disp('Converting image to binary format for feature extraction\n');
    binaryImg = im2bw(binaryImg);
    %binaryImg = centerobject(binaryImg);
  end
  
  %%%% Clean up %%%%%
  filledImg = imfill(binaryImg, 'holes');
  img = padarray(filledImg, [1, 1]);
 
  %%%%% Extract object properties %%%%%
  % Object area
  area = sum(img(:));
  
  % Object perimeter
  perimeterImg = img - imerode(img, structuralElement); 
  perimeter = sum(perimeterImg(:));
    
  % Convex area
  convexHullImg = bwconvhull(img);
  convexArea = sum(convexHullImg(:));
  
  % Convex perimeter
  convexPerimeterImg = convexHullImg - imerode(convexHullImg,structuralElement);
  convexPerimeter = sum(convexPerimeterImg(:));
  
  % Thickness
  tmpImg = img;
  thickness = 0;
  while any(tmpImg(:))
    tmpImg = imerode(tmpImg, structuralElement);
    thickness = thickness + 2;
  end
  
  %%%%% Calculate features %%%%%
  % Shape descriptors
  formFactor = area / (perimeter^2);
  elongatedness = area / (thickness^2);
  convexity = convexPerimeter / perimeter;
  solidity = area / convexArea;

  % Moment invariants
  areaMoments = GetMoments(img);
  perimeterMoments = GetMoments(perimeterImg); % No significant new info?
  
  features = [formFactor, elongatedness, convexity, solidity,...
              areaMoments];
  
end