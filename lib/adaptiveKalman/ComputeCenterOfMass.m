% Computing center of mass of binaryImage. Code borrowed from
% http://se.mathworks.com/matlabcentral/answers/155558-center-of-mass-of-binary-image
% date: 2016-05-16
function center = ComputeCenterOfMass(binaryImage)

  img = binaryImage;
  [x, y] = meshgrid(1:size(img, 2), 1:size(img, 1));
  weightedx = x .* img;
  weightedy = y .* img;
  xcenter = sum(weightedx(:)) / sum(img(:));
  ycenter = sum(weightedy(:)) / sum(img(:));
  center = [xcenter, ycenter];
  
end