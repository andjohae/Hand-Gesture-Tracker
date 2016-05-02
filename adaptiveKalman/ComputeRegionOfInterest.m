% COmputing the region of interest in a binary image
function [x,y,w,h] = ComputeRegionOfInterest(binaryImage)

  [y,x] = find(binaryImage);
  
  
  if(isempty(y) || isempty(x))
    x = -1; y = -1; w = -1; h = -1;
  else
    w = abs(x(1)-x(end));
    h = abs(y(1)-y(end));
    x = sort(x) ; y = sort(y);
    x = x(1); y = y(1);
  end

end