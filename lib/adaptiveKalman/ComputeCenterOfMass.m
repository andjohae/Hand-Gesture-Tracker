% Computing center of mass of binaryImage
function center = ComputeCenterOfMass(binaryImage)

  idxs = find(binaryImage);
  idxs = sum(idxs)/length(idxs);
  center = [idxs/size(binaryImage,1),idxs/size(binaryImage,2)];
  
end