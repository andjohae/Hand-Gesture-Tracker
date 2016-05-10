function gray = Ycc2Gray(image)

% Skin color extraction using hard coded a mean value..

MU = [99, 149];
height = size(image,1);
width = size(image,2);
y = rgb2ycbcr(image);

gray = zeros(height, width);


for i = 1:height
  for j = 1:width
    gray(i,j) = (norm([double(y(i,j,2)) double(y(i,j,3))] - MU,2));
  end
end

gray = gray - min(gray(:));
gray = gray ./ max(gray(:));

end
