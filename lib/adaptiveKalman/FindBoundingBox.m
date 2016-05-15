% Returns a suitable bounding box based on input size, center and image
% dims.
function boundingSquare = FindBoundingBox(imDims, boundingBox)

  boundingSquare = boundingBox;
  
  if(boundingSquare(1) < 1)
    boundingSquare(1) = 1;
  end
  
    
  if(boundingSquare(2) < 1)
    boundingSquare(2) = 1;
  end
  
    
  if(boundingSquare(1) + boundingSquare(3) > imDims(2))
    boundingSquare(1) = imDims(2) - boundingSquare(3);
  end
  
    
  if(boundingSquare(1) + boundingSquare(4) > imDims(1))
    boundingSquare(2) = imDims(1) - boundingSquare(4);
  end
  
  

end