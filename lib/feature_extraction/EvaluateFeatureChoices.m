function [errorRate, knownHandFeatures] = EvaluateFeatureChoices(imageDirPath,...
    selectedFeatures)
% Assumptions: Unix system, binary image with a single isolated object, ...
% TODO: Help text
  
  % Read and sort key table (assumed to exist in 'imageDirPath')
  key_fileID = fopen(strcat(imageDirPath, 'keytable.txt'), 'r');
  tmpKey = textscan(key_fileID,'%s\t%d','CommentStyle','%');
  fclose(key_fileID);
  [~, idx] = sort(tmpKey{1});
  key = tmpKey{2}(idx);
  
  % Initialize image loop
  files = dir(strcat(imageDirPath,'*.jpg'));
  nFiles = length(files);
  features = zeros(nFiles, length(selectedFeatures));
  
  % Loop over all image files in 'imageDirPath'
  for iFile = 1:nFiles
    % Read image from file
    filename = strcat(imageDirPath, files(iFile).name);
    img = imread(filename);
    
    % Get object features from image
    tmpFeatures = GetFeatures(img);
    features(iFile,:) = tmpFeatures(selectedFeatures)';
  end
 
  % Estimate error rate from feature classification
  isWrongClass = ClassifyHands(features, selectedFeatures) ~= key;
  errorRate = sum(isWrongClass) / nFiles;

  % Return features of known hands --- Temporary
  knownHandFeatures = features(logical(key),:);
  
end