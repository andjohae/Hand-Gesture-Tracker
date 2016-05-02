function bin = Hsv2Binary(image, lims)

% Skin color extraction using a lims given in
% YCrCb color format for [Cb; Cr].

h = rgb2hsv(image);


bin = lims(1,1) <= h(:,:,1) & h(:,:,1) <= lims(1,2)...
    & lims(2,1) <= h(:,:,2) & h(:,:,2) <= lims(2,2);

end