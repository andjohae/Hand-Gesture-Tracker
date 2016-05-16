% Initialize image loop
addpath(genpath('./'));
files = dir('*.jpg');
nFiles = length(files);

filePrefix = 'bin_';
se = strel('disk',5);
% Loop over all image files in 'imageDirPath'
for i = 1:nFiles
  % Read image from file
  img = imread(files(i).name);
  
  % Convert to binary
  binaryImg = bwareafilt(Ycc2Binary(img),1);
  binaryImg = imfill(binaryImg, 'holes');
  binaryImg = imdilate(binaryImg,se);
  imshow(binaryImg)
  
  % Write to file
  imwrite(binaryImg, strcat(filePrefix,files(i).name));
end
