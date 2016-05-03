function neighbourIndices = GetLinearNeighbourIndices(linearIndex,gridSize)
% Returns neighbouring indices in a Von Neumann (4-way) neighbourhood using
% peridodic boundary conditions.
  
  [row, col] = ind2sub(gridSize,linearIndex);

  neighbours = [(1+mod((row+1)-1,gridSize(1))), col; % Down
                row, (1+mod((col+1)-1,gridSize(2))); % Right
                (1+mod((row-1)-1,gridSize(1))), col; % Up
                row, (1+mod((col-1)-1,gridSize(2)))  % Left
               ];

  neighbourIndices = sub2ind(gridSize,neighbours(:,1),neighbours(:,2));
             
end