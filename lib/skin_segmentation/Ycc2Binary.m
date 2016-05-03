function bin = Ycc2Binary(image)

% Skin color extraction using a LIMITS given in
% YCbCr color format for [Cb; Cr].

% Limits from "Summary of..."
LIMITS = [77 127; 133 177];

y = rgb2ycbcr(image);

bin = LIMITS(1,1) <= y(:,:,2) & y(:,:,2) <= LIMITS(1,2)...
    & LIMITS(2,1) <= y(:,:,3) & y(:,:,3) <= LIMITS(2,2);

end
