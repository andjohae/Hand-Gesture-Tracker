% Computing center of mass of binary image I.
function center = ComputeCenterOfMass(I)

  na = sum(sum(I));
  x = sum(sum(I.*repmat([1:size(I,2)],size(I,1),1)))/na;
  y = sum(sum(I.*repmat([1:size(I,1)]',1,size(I,2))))/na;
  center = [x,y];
  
end