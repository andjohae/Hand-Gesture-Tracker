function [bestFeatures, minErrorRates] = FindBestFeatures(imageDirPath, nTotalFeatures)

  % Read features and key table from images
  [features, key] = ReadImageFeatures(imageDirPath, nTotalFeatures);
 
  % Initialize classification loop
  minErrorRates = zeros(nTotalFeatures,1);
  bestFeatures = cell(nTotalFeatures,1);
  
  % Loop over feature combinations
  for iNumUsedFeatures = 1:nTotalFeatures
    featureCombinations = combnk(1:nTotalFeatures, iNumUsedFeatures);
    nCombinations = size(featureCombinations,1);
    errorRates = zeros(nCombinations,1);
    
    for iComb = 1:nCombinations
      isWrongClass = ClassifyHands(features(:,featureCombinations(iComb)),...
          featureCombinations(iComb)) ~= key;
      errorRates(iComb) = sum(isWrongClass) / nFiles;
    end
    
    % Find and store best error rate and feature combination
    [tmpBestError, iBestError] = min(errorRates);
    minErrorRates(iNumUsedFeatures) = tmpBestError;
    bestFeatures{iNumUsedFeatures} = featureCombinations(iBestError,:);
  end
  
end