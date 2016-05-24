%% Testfile for SVM
addpath(genpath('./../images'))
addpath(genpath('./../lib'))
addpath(genpath('./lib'))
addpath(genpath('./images'))


load('./images/feature-eval-images/feature_values.mat')
idxs = crossvalind('Kfold',size(features,1),5);
cp = classperf(key);
for i = 1:5
    test = (idxs == i); train = ~test;
    model = fitcsvm(features(train,:),key(train,:));
    class = predict(model,features(test,:));
    classperf(cp,class,test);
end
cp.DiagnosticTable