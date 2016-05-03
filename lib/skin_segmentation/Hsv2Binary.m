function bin = Hsv2Binary(image)

% Skin color extraction using a hard coded LIMITS
% HSV color format for Hue and Saturation.

LIMITS = [0 0.5; 0.2 0.68];
h = rgb2hsv(image);

bin = LIMITS(1,1) <= h(:,:,1) & h(:,:,1) <= LIMITS(1,2)...
    & LIMITS(2,1) <= h(:,:,2) & h(:,:,2) <= LIMITS(2,2);

end
