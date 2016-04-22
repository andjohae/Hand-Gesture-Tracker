function midwayThreshold = UpperThreshold(image)
  % Estimates a threshold starting from 255 and moving 
  % down until a minimum is estimated.
  %
  % Parameters: 
  %   image - Greyscale image
  
  [binCounts, ~] = histcounts(image, 0:256);

  threshold = round(initialThreshold);
  tmpThreshold = -1;
  
  while (threshold ~= tmpThreshold)
    
    lowMean = sum((1:threshold) .* binCounts(1:threshold)) ./ ...
        sum(binCounts(1:threshold));
    highMean = sum((threshold+1:256) .* binCounts(threshold+1:end)) ./ ...
        sum(binCounts(threshold+1:end));
    
    tmpThreshold = round((lowMean + highMean)./2);
    
    if (threshold == tmpThreshold)
      break;
    else
      threshold = tmpThreshold;
    end
    
  end
  
  midwayThreshold = threshold;
  
end