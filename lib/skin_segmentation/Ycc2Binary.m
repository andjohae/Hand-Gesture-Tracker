function bin = Ycc2Binary(image, mu)

% Skin color extraction using a mean value given in
% YCrCb color format.

height = size(image,1);
width = size(image,2);


y = rgb2ycbcr(image);

bin = zeros(height, width);

for i = 1:height
  for j = 1:width
    bin(i,j) = norm([double(y(i,j,2)) double(y(i,j,3))] - mu,2) < 45;
  end
end

end
