function class = ClassifyHands(features, selectedFeatures)
%   TODO: Choose classification method
%   Should return a logical row vector of size [size(features,1), 1]
  
  % NOTE: Should the parameters be obtained as arguments?
  % Parameters
  meanFeatures = [0.000312738406930,...
                  3.209135856122326,...
                  0.097111777963935,...
                  0.724660259705732];
  
  stdFeatures = [0.000073660785100,...
                 0.717449069600985,...
                 0.008652822868377,...
                 0.120641023013056];
               
  regionWidth = 1.96;             
  
  % Initialization
  minFeatures = meanFeatures - regionWidth * stdFeatures;
  maxFeatures = meanFeatures + regionWidth * stdFeatures;
  
  minFeatures = minFeatures(selectedFeatures);
  maxFeatures = maxFeatures(selectedFeatures);
  features = features(:,selectedFeatures);
  nCases = size(features,1);
  
  % Classify hands
  isAllowed = (features > (ones(nCases,1) * minFeatures)) &...
          (features < (ones(nCases,1) * maxFeatures));
  class = all(isAllowed,2);
    
end