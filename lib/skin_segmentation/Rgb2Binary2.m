function bin = Rgb2Binary2(image)

% Skin color extraction using a LIMITS given in
% xyz color format.

image = double(image);
summed = sqrt(sum(image.^2,3));
red = image(:,:,1) ./ summed;
green = image(:,:,2) ./ summed;
blue = image(:,:,3) ./ summed;


LIMITS = [0.5 1; 0 1; 0.4 0.6];

bin = LIMITS(1,1) <= red & red <= LIMITS(1,2)...
    & LIMITS(2,1) <= blue & blue <= LIMITS(2,2)...
    & LIMITS(3,1) <= green & green <= LIMITS(3,2);

end
