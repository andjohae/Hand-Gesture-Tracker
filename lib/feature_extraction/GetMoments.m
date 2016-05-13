function moments = GetMoments(binaryImage)
  
  % Normalize pixel distribution - makes the central moments normalized
  binaryImage = binaryImage./sum(binaryImage(:));
  
  [yLength, xLength] = size(binaryImage);
  [Y, X] = meshgrid(yLength,xLength);
  
  meanX = sum(binaryImage,1) * (1:xLength)';
  meanY = sum(binaryImage,2)' * (1:yLength)';

  integrand = @(p,q) (X - meanX).^p .* (Y - meanY).^q .* binaryImage;

  % Compute central moments - translation and scaling invariant
  cm_11 = sum(sum( integrand(1,1) ));
  cm_20 = sum(sum( integrand(2,0) ));
  cm_02 = sum(sum( integrand(0,2) ));
  cm_30 = sum(sum( integrand(3,0) ));
  cm_21 = sum(sum( integrand(2,1) ));
  cm_12 = sum(sum( integrand(1,2) ));
  cm_03 = sum(sum( integrand(0,3) ));
  
  % Moment invariants - rotation and mirror invariant
  moments = zeros(1,6);
  moments(1) = cm_20 + cm_02;
  moments(2) = (cm_20 - cm_02)^2 + 4*cm_11^2;
  moments(3) = (cm_30 - 3*cm_12)^2 + (cm_03 - 3*cm_21)^2;
  moments(4) = (cm_30 + cm_12)^2 + (cm_03 + cm_21)^2;
 
  moments(5) = (cm_30 - 3*cm_12)*(cm_30 + cm_12) * ((cm_30 + cm_12)^2 - ...
      3*(cm_21 + cm_03)^2) + (3*cm_21 - cm_03)*(cm_21 + cm_03) * ...
      ( 3*(cm_30 + cm_12)^2 - (cm_21 + cm_03)^2 );
  
  moments(6) = (cm_20 - cm_02) * ( (cm_30 + cm_12)^2 - (cm_21 + cm_03)^2 ) ...
      + 4 * cm_11 * (cm_30 + cm_12) * (cm_21 + cm_03);
    
  % Use natural logarithm of moments to achieve numerical stability
  moments = log(moments(1:6));
  
end