% Skin color extractor using YCbCr information.
function binaryImage = ExtractSkinColor(jpegImage)

  ycbcrImage = rgb2ycbcr(jpegImage);
  Cb = ycbcrImage(:,:,2);
  Cr = ycbcrImage(:,:,3);
  
  % Used from article..
  muCr = 149.7692;
  muCb = 114.3846;
  sigmaCr = 13.80914;
  sigmaCb = 7.136041;
  CbLowerBound = muCb - sigmaCb;
  CbUpperBound = muCb + sigmaCb;
  CrLowerBound = muCr - sigmaCr;
  CrUpperBound = muCr + sigmaCr;
  
  xDim = length(ycbcrImage(:,1,1));
  yDim = length(ycbcrImage(1,:,1));
  
  for i = 1:xDim
    for j = 1:yDim
      if( (CbLowerBound < Cb(i,j) && Cb(i,j) < CbUpperBound) && ...
          (CrLowerBound < Cr(i,j) && Cr(i,j) < CrUpperBound))
        binaryImage(i,j) = true; 
      else 
        binaryImage(i,j) = false;
      end
    end
  end
  
  binaryImage = imdilate(binaryImage, strel('disk',3));

end