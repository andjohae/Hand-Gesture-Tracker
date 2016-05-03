function filledImage = FillAreaInsideBoundary(boundary,imgSize,seed_index)
% TODO: Write help text
  
  % Create logical mask for boundary
  boundary_mask = false(imgSize(1),imgSize(2));
  boundary_mask(boundary) = 1;
  
  % Initialize filler layer
  filler_layer = false(imgSize(1),imgSize(2));
  previous_filler_layer = filler_layer;
  filler_layer(seed_index) = 1;
  
  % Create structural element used for morphological operations
  structural_element = strel('square',3);
  
  % --- Grow area filler ---
  while ~isequal(filler_layer, previous_filler_layer)
    
    % Store previous layer_mask
    previous_filler_layer = filler_layer;
    
    % Grow previous layer
    filler_layer = imdilate(filler_layer, structural_element);
    
    % Remove elements that overlap with the boundary
    filler_layer = filler_layer - filler_layer .* boundary_mask;

  end
  
  % Return the combined image of both the filling and the boundary
  filledImage = filler_layer + boundary_mask;
  
end