
feature=[];
label=[];
for i=0:9
    stru=load(strcat('D:\USC\Sem 2\Pattern Recoginition\Project\Test Data Images\TEST_DATA\',num2str(i),'.mat'));
    feature=[feature;stru.feature_train];
    label=[label;stru.label_train];
end
input 'save?'
save('D:\USC\Sem 2\Pattern Recoginition\Project\Test Data Images\TEST_DATA\feature_test.mat','feature');
save('D:\USC\Sem 2\Pattern Recoginition\Project\Test Data Images\TEST_DATA\label_test.mat','label');