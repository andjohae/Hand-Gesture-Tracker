function bin = Rgb2Binary(image)

% Skin color extraction using a LIMITS given in
% YCrCb color format for [Cb; Cr].

normed = double(image);
summed = sum(image,3);
red = normed(:,:,1) ./ summed;
blue = normed(:,:,3) ./ summed;

LIMITS = [0.3 0.65; 0.2 0.4];
y = rgb2ycbcr(image);

bin = LIMITS(1,1) <= red & red <= LIMITS(1,2)...
    & LIMITS(2,1) <= blue & blue <= LIMITS(2,2);

end
