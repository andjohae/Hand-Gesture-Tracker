function [bestFeatures, minErrorRates] = FindBestFeatures(imageDirPath, nTotalFeatures)

  % Read and sort key table (assumed to exist in 'imageDirPath')
  key_fileID = fopen(strcat(imageDirPath, 'keytable.txt'), 'r');
  tmpKey = textscan(key_fileID,'%s\t%d','CommentStyle','%');
  fclose(key_fileID);
  [~, idx] = sort(tmpKey{1});
  key = tmpKey{2}(idx);
  
  % Initialize image read loop
  files = dir(strcat(imageDirPath,'*.jpg'));
  nFiles = length(files);
  features = zeros(nFiles,nTotalFeatures);
  
  % Loop over all image files in 'imageDirPath'
  for iFile = 1:nFiles
    % Read image from file and convert to logical
    filename = strcat(imageDirPath, files(iFile).name);
    binaryImg = logical(imread(filename));
    
    % Get object features from image
    features(iFile,:) = GetFeatures(binaryImg);
  end
 
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