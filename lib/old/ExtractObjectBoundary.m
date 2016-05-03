function boundary = ExtractObjectBoundary(image)
% Finds and returns a row vector containing the linear indicies of the
% boundary of an object in a binary image. 
% The image is assumed to have '0' as the background and '1' as the object.

  % --- Initialization ---
  imgSize = size(image);
  boundary = zeros(10^6, 1);
  boundary(1) = find(image, 1);
  iBoundaryPos = 3;
  
  % Find first neighbour containing object
  neighbours = GetLinearNeighbourIndices(boundary(1),imgSize);
  sortedNeighbourIndex = find( image(neighbours), 1 );
  directionCounter = mod( sortedNeighbourIndex - 2, 4 ) + 1;
  boundary(2) = neighbours(sortedNeighbourIndex);
  
  % --- Main loop ---
  while ( true )
    % Get Neighbours and start counting from 'indexCounter'
    neighbours = GetLinearNeighbourIndices(boundary(iBoundaryPos-1),imgSize);
    neighbours = [neighbours(directionCounter:end); ...
                  neighbours(1:directionCounter-1)];
    
    % Find first neighbour containing object
    unsortedNeighbourIndex = find(image(neighbours), 1);
    
    % Correct neighbour index for order of neighbours
    sortedNeighbourIndex = mod(unsortedNeighbourIndex + directionCounter -2, 4) +1;
    
    % Keep track of index counter for neighbours
    directionCounter = mod( sortedNeighbourIndex - 2, 4 ) + 1;
    
    % Store linear index of boundary position
    boundary(iBoundaryPos) = neighbours(unsortedNeighbourIndex);
    
    % Break if boundary is closed
    if (boundary(iBoundaryPos) == boundary(2))
      break;
    end
    
    % Increment counter
    iBoundaryPos = iBoundaryPos + 1;
  end
  
  % --- Clean up ---
  boundary( boundary == 0 ) = [];
  boundary(end-1:end) = []; % Last two boundary elements are the first two

end