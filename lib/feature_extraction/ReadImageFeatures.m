function [features, key] = ReadImageFeatures(imageDirPath, nFeatures)

  % Read and sort key table (assumed to exist in 'imageDirPath')
  key_fileID = fopen(strcat(imageDirPath, 'keytable.txt'), 'r');
  tmpKey = textscan(key_fileID,'%s\t%d','CommentStyle','%');
  fclose(key_fileID);
  [~, idx] = sort(tmpKey{1});
  key = tmpKey{2}(idx);
  
  % Initialize image read loop
  files = dir(strcat(imageDirPath,'*.jpg'));
  nFiles = length(files);
  features = zeros(nFiles,nFeatures);
  
  % Loop over all image files in 'imageDirPath'
  for iFile = 1:nFiles
    % Read image from file and convert to logical
    filename = strcat(imageDirPath, files(iFile).name);
    binaryImg = logical(imread(filename));
    
    % Get object features from image
    features(iFile,:) = GetFeatures(binaryImg);
  end

end