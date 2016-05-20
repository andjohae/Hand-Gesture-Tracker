function class = ClassifyWithMinMax(features, selectedFeatures)
  % Parameters
               
  minFeatures = [0.0000,...
                 0.1952,...
                 0.1868,...
                 0.0112,...
                 10.5334,...
                 21.0668,...
                 31.6001,...
                 31.6001,...
                 63.2003,...
                 42.1335];
               
   maxFeatures = [0.0020,...
                  16.4323,...
                  0.3677,...
                  0.7725,...
                  16.0471,...
                  32.0943,...
                  48.1414,...
                  48.1414,...
                  96.2828,...
                  64.1885];
  
  minFeatures = minFeatures(selectedFeatures);
  maxFeatures = maxFeatures(selectedFeatures);
  nCases = size(features,1);
  
  % Classify hands
  isAllowed = (features > (ones(nCases,1) * minFeatures)) &...
          (features < (ones(nCases,1) * maxFeatures));
  class = all(isAllowed,2);
    
end