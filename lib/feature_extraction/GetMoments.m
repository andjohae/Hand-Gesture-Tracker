function moments = GetMoments(binaryImage)
  
  % Normalize pixel distribution - makes the central moments normalized
  binaryImage = binaryImage./sum(binaryImage(:));
  
  [yLength, xLength] = size(binaryImage);
  [Y, X] = meshgrid(yLength,xLength);
  
  meanX = sum(binaryImage,1) * (1:xLength)';
  meanY = sum(binaryImage,2)' * (1:yLength)';

  integrand = @(p,q) (X - meanX).^p .* (Y - meanY).^q .* binaryImage;

  % Compute central moments - translation and scaling invariant
  centralMoment_11 = sum(sum( integrand(1,1) ));
  centralMoment_20 = sum(sum( integrand(2,0) ));
  centralMoment_02 = sum(sum( integrand(0,2) ));
  centralMoment_30 = sum(sum( integrand(3,0) ));
  centralMoment_21 = sum(sum( integrand(2,1) ));
  centralMoment_12 = sum(sum( integrand(1,2) ));
  centralMoment_03 = sum(sum( integrand(0,3) ));
  
  % Moment invariants - rotation (and mirror?) invariant
  moments = zeros(1,4);
  moments(1) = centralMoment_20 + centralMoment_02;
  moments(2) = (centralMoment_20 - centralMoment_02)^2 + 4*centralMoment_11^2;
  moments(3) = (centralMoment_30 - 3*centralMoment_12)^2 + ...
               (centralMoment_03 - 3*centralMoment_21)^2;
  moments(4) = (centralMoment_30 + centralMoment_12)^2 + ...
               (centralMoment_03 + centralMoment_21)^2;
   
  % Use natural logarithm of moments to achieve numerical stability
  moments = log(moments);
  
end