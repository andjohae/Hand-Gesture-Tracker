function midwayThreshold = MidwayThreshold(image,initialThreshold)
  % Estimate bimodal threshold value in greyscale image using the midway method,
  % starting from the specified initial thershold value.
  %
  % Parameters: 
  %   image - Greyscale image
  %   initialThreshold - Initial guess at threshold (0 < T_0 < 255) 
  
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