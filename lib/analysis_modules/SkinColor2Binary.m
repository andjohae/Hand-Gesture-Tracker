%% Skin color extractor.
% Input 
function newImage = SkinColor2Binary(oldImage)

newImage    = (oldImage(:,:,1) > oldImage(:,:,2)) & ...
           (oldImage(:,:,2) > oldImage(:,:,3));

end
