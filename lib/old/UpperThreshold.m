function th = UpperThreshold(image)
% Estimates a threshold starting from 255 and moving
% down until a minimum is estimated.
%
% Parameters:
%   image - Greyscale image

[binCounts, ~] = histcounts(image, 0:1:256);


th = find(binCounts,1,'last') - 2;
max = 0;
while th > 1
  % count at th
  %tmp = binCounts(th + 1);
  tmp = mean(binCounts((th-2):(th+2)));
  if tmp > max
    max = tmp;
  elseif tmp < 0.8*max
    break
  end
  th = th - 1;
end

min = max;
while th > 1
  %tmp = binCounts(th + 1);
  tmp = mean(binCounts((th-2):(th+2)));
  if tmp <= min
    min = tmp;
  else
    break
  end
  th = th - 1;
end

end