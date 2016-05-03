function bin = Ycc2Binary(image)

% Skin color extraction using a LIMITS given in
% YCrCb color format for [Cb; Cr].

LIMITS = [100 130; 125 165];
y = rgb2ycbcr(image);

bin = LIMITS(1,1) <= y(:,:,2) & y(:,:,2) <= LIMITS(1,2)...
    & LIMITS(2,1) <= y(:,:,3) & y(:,:,3) <= LIMITS(2,2);

end
