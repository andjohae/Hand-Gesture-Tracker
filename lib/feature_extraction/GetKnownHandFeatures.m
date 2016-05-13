function knownHandFeatures = GetKnownHandFeatures(imageDirPath, ...
    selectedFeatures)
% TODO: Write help text!
  
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
    % Only calculate features for actual hands
%     if ~logical(key(iFile))
%       continue;
%     end
      
    % Read image from file
    filename = strcat(imageDirPath, files(iFile).name);
    img = imread(filename);
    
    % Convert to binary
    binaryImg = logical(img);
    
    % Get object features from image
    tmpFeatures = GetFeatures(binaryImg);
    features(iFile,:) = tmpFeatures(selectedFeatures);
  end
  
  % Return features of known hands
  knownHandFeatures = features(logical(key),:);
  
end