% ExtractMotion
function binaryImage = ExtractMotion(prevJpegImage, curJpegImage)

  Fd_t = abs(prevJpegImage - curJpegImage);
  Fdg_t = 0.299.*Fd_t(:,:,1) + 0.587.*Fd_t(:,:,2) + 0.114.*Fd_t(:,:,3); 
  %Fdg_t = rgb2gray(Fd_t);
  threshold = 0.01*sum(sum(Fdg_t))./prod(size(Fdg_t))
  
  binaryImage = ((Fdg_t ./ 255) >= threshold);

end