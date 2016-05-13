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
% Note that all features are size invariant.
  
  % Initialization
  structuralElement = strel('square',3);
  
  %%%%% Extract object properties %%%%%
  
  % Object perimeter
  perimeterImg = binaryImg - imerode(binaryImg, structuralElement); 
  perimeter = sum(perimeterImg(:));
    
  % Object area
  filledImg = imfill(perimeterImg);
  area = sum(filledImg(:));
    
  % Convex area
  convexHullImg = bwconvhull( filledImg );
  convexArea = sum(convexHullImg(:));
  
  % Convex perimeter
  convexPerimeterImg = convexHullImg - imerode(convexHullImg,structuralElement);
  convexPerimeter = sum(convexPerimeterImg(:));
  
  % Thickness
  tmpImg = binaryImg;
  thickness = 0;
  while any(tmpImg(:))
    tmpImg = imerode(tmpImg, structuralElement);
    thickness = thickness + 2;
  end
  
  %%%%% Calculate features %%%%%
  formFactor = area / (perimeter^2);
  elongatedness = area / (thickness^2);
  convexity = convexPerimeter / perimeter;
  solidity = area / convexArea;

  % Calculate moments
  areaMoments = GetMoments(binaryImg);
%   perimeterMoments = GetMoments(perimeterImg); % No significant new info?
  
  features = [formFactor, elongatedness, convexity, solidity,...
              areaMoments];
  
end