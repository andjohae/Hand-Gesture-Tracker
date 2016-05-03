% Computing center of mass..
function center = ComputeCenterOfMass(binaryImage)

[y, x] = find( binaryImage );
center = [mean(x), mean(y)];

end