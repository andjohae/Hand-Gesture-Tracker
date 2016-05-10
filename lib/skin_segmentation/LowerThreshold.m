function th = LowerThreshold(image)
% Estimates a threshold starting from 255 and moving
% down until a minimum is estimated.
%
% Parameters:
%   image - Greyscale image

n = 50;
[binCounts, ~] = histcounts(image, linspace(0,1,n));
th = 3;
max = 0;
while th < n
  % count at th
  tmp = binCounts(th + 1);
  %tmp = mean(binCounts((th-2):(th+2)));
  if tmp > max
    max = tmp;
  elseif tmp < 0.5*max
    break
  end
  th = th + 1;
end


min = max;
while th > 1
  tmp = binCounts(th + 1);
  %tmp = mean(binCounts((th-2):(th+2)));
  if tmp <= min
    min = tmp;
  else
    break
  end
  th = th - 1;
end

th = th / n;

end