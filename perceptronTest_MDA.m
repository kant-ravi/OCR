load('D:\USC\Sem 2\Pattern Recoginition\Project Final\Data_Feature_Space\Training\feature_train.mat');
load('D:\USC\Sem 2\Pattern Recoginition\Project Final\Data_Feature_Space\Training\label_train.mat');
%%
subSetSize=5000;
k=1;

[nSamples,nFeatures]=size(feature);
nClasses=size(unique(label),1);
count=zeros(nClasses,1);
feature_train=zeros(subSetSize,nFeatures);
label_train=zeros(subSetSize,1);

numPerClassSamples=subSetSize/nClasses;


while k<=subSetSize
    ind = randi([1 nSamples],1,1);
    if label(ind)~=0
        if count(label(ind))<numPerClassSamples
            feature_train(k,:)=feature(ind,:);
            label_train(k,1)=label(ind,1);
            count(label(ind),1)=count(label(ind),1)+1;
            k=k+1;
        end
    else
        if count(nClasses)<numPerClassSamples
            feature_train(k,:)=feature(ind,:);
            label_train(k,1)=label(ind,1);
            count(nClasses,1)=count(nClasses,1)+1;
            k=k+1;
        end
    end
end
input('proceed?');
fprintf('working...');

feature=feature_train;
label=label_train;
%%
[feature,label]=MultipleDiscriminantAnalysis(feature', label');
feature=feature';
label=label';
train_patterns=((feature))';
train_targets=label';
load('D:\USC\Sem 2\Pattern Recoginition\Project Final\Data_Feature_Space\Testing\feature_test.mat')
load('D:\USC\Sem 2\Pattern Recoginition\Project Final\Data_Feature_Space\Testing\label_test.mat')
%feature=feature(:,1:8);
[feature,label]=MultipleDiscriminantAnalysis(feature', label');
feature=feature';
label=label';
test_patterns=((feature))';
test_targets=label';

predictedLabels = multiclass(train_patterns, train_targets, test_patterns, '[''OAA'', 0, ''Perceptron'', []]');
disp '-------------------------------------------------------'
disp 'Multiclass One-against-all Perceptron Test accuracy'
disp(mean(predictedLabels == test_targets))
disp '-------------------------------------------------------'
disp 'Multiclass One-against-all MSE Test accuracy'
predictedLabels = multiclass(train_patterns, train_targets, test_patterns, '[''OAA'', 0, ''LS'', []]');
disp(mean(predictedLabels == test_targets))
disp '-------------------------------------------------------'
disp '-------------------------------------------------------'
