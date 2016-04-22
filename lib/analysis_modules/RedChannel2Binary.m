function binary = RedChannel2Binary(I)
  % Converts a RGB images to binary image looking only at 
  % the red channel
  %
  % Parameters: 
  %   I - RGB image
  
  red = I(:,:,1);
  
  th = 250;
  th = MidwayThreshold(red,th);
  red(red < th) = 0;
  red(red >= th) = 1;
  binary = red;
end