%% Skin color extractor.
% Input 
function newImage = SkinColor2Binary(oldImage)

redCh       = double(oldImage(:,:,1));
greenCh     = double(oldImage(:,:,2));
blueCh      = double(oldImage(:,:,3));
structElem  = strel('disk',3);
%newImage    = imdilate((redCh > greenCh) & greenCh > blueCh,structElem);
newImage    = (redCh > greenCh) & greenCh > blueCh;
newImage    = imopen(newImage,structElem);


end
