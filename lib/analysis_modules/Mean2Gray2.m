%% Skin color extractor from a given mean in normalized RGB.
function gray = Mean2Gray2(image, mu)

width = size(image,1);
height = size(image,2);

image = double(image);

sumImage = sqrt(sum(image,3));

redNorm = 255 * image(:,:,1) ./ sumImage;
greenNorm = 255 * image(:,:,2) ./ sumImage;
blueNorm = 255 * image(:,:,3) ./ sumImage;

gray = zeros(width, height);

for i = 1:width
  for j = 1:height
    gray(i,j) = norm([redNorm(i,j)...
                      greenNorm(i,j)...
                      blueNorm(i,j)] - mu,2);
  end
end

gray = gray ./ max(gray(:));
gray = 255 * (1 - gray);
end
