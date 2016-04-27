%% Skin color extractor.
% Input 
function newImage = SkinColor2Binary(oldImage)

structElem  = strel('disk',3);
newImage    = im2bw(oldImage(:,:,1),0.7);
newImage    = imopen(newImage,structElem);


end
