%% Skin color extractor from a given mean in vanilla RGB.
function gray = Mean2Gray1(image, mu)

width = size(image,1);
height = size(image,2);

gray = zeros(width, height);

max = 441.6730;
scale = 255/max;

for i = 1:width
  for j = 1:height
    gray(i,j) = scale*(max - norm([double(image(i,j,1)) ...
                                   double(image(i,j,2)) ....
                                   double(image(i,j,3))] - mu,2));
  end
end

end
