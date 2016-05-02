function bin = Ycc2Binary(image, lims)

% Skin color extraction using a lims given in
% YCrCb color format for [Cb; Cr].

y = rgb2ycbcr(image);


bin = lims(1,1) <= y(:,:,2) & y(:,:,2) <= lims(1,2)...
    & lims(2,1) <= y(:,:,3) & y(:,:,3) <= lims(2,2);

end