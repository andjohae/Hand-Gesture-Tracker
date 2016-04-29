% function errorRate = EvaluateFeatureChoices(imageDirPath, selectedFeatures)
% Assumptions: Unix system, binary image with a single isolated object, ...

  % REMOVE AFTER DEVELOPMENT
  clc;
  imageDirPath = '../../images/feature-eval-images/';
  selectedFeatures = 1:4;
  
  % Make sure 'imageDirPath' ends with '/'
  if ( imageDirPath(end) ~= '/' )
    imageDirPath = strcat(imageDirPath, '/');
  end
  
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
    imshow(img); shg % REMOVE LINE
    pause(1); % REMOVE LINE
    
    % Get object features from image
    tmpFeatures = GetFeatures(img);
    features(iFile,:) = tmpFeatures(selectedFeatures)';
  end
 
  %% Print out
  clc
  fprintf('Form factor \tElongatedness \tConvexity \tSolidity\n');
  fprintf('---------------------------------------------------------\n');
  fprintf('%.6f \t%.6f \t%.6f \t%.6f\n', features');
  fprintf('---------------------------------------------------------\n');
  fprintf('%.6f \t%.6f \t%.6f \t%.6f | mean\n', mean(features));
  fprintf('%.6f \t%.6f \t%.6f \t%.6f | std\n', std(features));
  
  %% Estimate error rate from feature classification
  isWrongClass = ClassifyHands(features, selectedFeatures) ~= key;
  errorRate = sum(isWrongClass) / nFiles;
  
% end

% function handBool = ClassifyHands(features, selectedFeatures)
  % TODO: Choose classification method
  % Should return a logical row vector of size [size(features,1), 1]
  % This subfunction could be placed in a separate file!
% end