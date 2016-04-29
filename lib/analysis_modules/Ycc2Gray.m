function gray = Ycc2Gray(image, mu)

% Skin color extraction using a mean value given in
% YCrCb color format.

height = size(image,1);
width = size(image,2);


y = rgb2ycbcr(image);

gray = zeros(height, width);

max = norm([255 255]);
scale = 255/max;

for i = 1:height
  for j = 1:width
    gray(i,j) = scale* (max - norm([double(y(i,j,2)) double(y(i,j,3))] - mu,2));
  end
end

end
