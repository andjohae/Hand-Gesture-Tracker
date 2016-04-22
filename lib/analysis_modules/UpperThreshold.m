function th = UpperThreshold(image)
% Estimates a threshold starting from 255 and moving
% down until a minimum is estimated.
%
% Parameters:
%   image - Greyscale image

[binCounts, ~] = histcounts(image, 0:256);

th = find(binCounts,1,'last') - 1;
max = 0;
while th > 1
  % count at th
  tmp = binCounts(th + 1);
  if tmp > max
    max = tmp;
  elseif tmp < 0.1*max
    break
  end
  th = th - 1;
end

end