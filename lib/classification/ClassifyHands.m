function class = ClassifyHands(features, selectedFeatures)
%   TODO: Choose classification method!
%   Should return a logical row vector of size [size(features,1), 1]
  
  % Parameters
  meanFeatures = [0.001544046,...
                  3.193153856,...
                  0.216405314,...
                  0.721578859,...
                  12.360359725,...
                  24.720719450,...
                  37.081079175,...
                  37.081079175,...
                  74.162158350,...
                  49.441438900];
  
  stdFeatures = [0.000352009,...
                 0.775516448,...
                 0.015795758,...
                 0.135856250,...
                 1.070109411,...
                 2.140218821,...
                 3.210328232,...
                 3.210328232,...
                 6.420656464,...
                 4.280437643];

  regionWidth = 1.96;
  
  % Initialization
  minFeatures = meanFeatures - regionWidth * stdFeatures;
  maxFeatures = meanFeatures + regionWidth * stdFeatures;
  
  minFeatures = minFeatures(selectedFeatures);
  maxFeatures = maxFeatures(selectedFeatures);
  nCases = size(features,1);
  
  % Classify hands
  isAllowed = (features > (ones(nCases,1) * minFeatures)) &...
          (features < (ones(nCases,1) * maxFeatures));
  class = all(isAllowed,2);
    
end