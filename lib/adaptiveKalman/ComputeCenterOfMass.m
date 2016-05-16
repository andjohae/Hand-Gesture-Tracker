% Computing center of mass of binaryImage
function center = ComputeCenterOfMass(binaryImage)

  img = binaryImage;
  [x, y] = meshgrid(1:size(img, 2), 1:size(img, 1));
  weightedx = x .* img;
  weightedy = y .* img;
  xcenter = sum(weightedx(:)) / sum(img(:));
  ycenter = sum(weightedy(:)) / sum(img(:));
  center = [xcenter, ycenter];
  
end