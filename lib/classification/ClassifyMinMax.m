function class = ClassifyMinMax(features, minFeatures, maxFeatures)

  minFeatures = minFeatures(selectedFeatures);
  maxFeatures = maxFeatures(selectedFeatures);
  nCases = size(features,1);
  
  isAllowed = (features > (ones(nCases,1) * minFeatures)) &...
          (features < (ones(nCases,1) * maxFeatures));
  class = all(isAllowed,2);
    
end