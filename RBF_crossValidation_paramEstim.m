clear
clc
load('D:\USC\Sem 2\Pattern Recoginition\Project\Padagog\Training Data\feature_train.mat');
load('D:\USC\Sem 2\Pattern Recoginition\Project\Padagog\Training Data\label_train.mat');
fprintf('\nTraining data loaded')
%% Normalize
feature=zscore(feature);
[nSamples,nFeatures]=size(feature);
nClasses=size(unique(label),1);
fprintf('\n Normalizing Done')
%% data has 5000 samples of each digit 
fprintf('\n Selecting 50000 samples; 1000 of each digit grouped into 5 folds')
numFolds=5;
numSubFolds=4;

foldSize=10000; %numSamplesPerFold
numSamplesPerDigitPerFold=1000;

% Draw 1000 samples of each digit to form a fold, do this 5 times with out
% repeating samples

chkBit=label; % this will be made -99 once a sample has been assigned to a fold

% each time you run this, you will have 50,000 samples that are randomly
% ordered. So when you make folds out of them, each set folds will be
% different from the previous run

curFold=1;
tempFeature=[];
tempLabel=[];
while curFold<=numFolds
    k=1;
    count=zeros(nClasses,1); % to keep a count of num samples per digit
    feature_fold=zeros(foldSize,nFeatures);
    label_fold=zeros(foldSize,1);
    while k<=foldSize
        ind = randi([1 nSamples],1,1);              % random index, check if assigned to a fold, if not assign to the current fold
        if chkBit(ind)~=-99
            if label(ind)~=0
                if count(label(ind))<numSamplesPerDigitPerFold
                    feature_fold(k,:)=feature(ind,:);
                    label_fold(k,1)=label(ind,1);
                    count(label(ind),1)=count(label(ind),1)+1;
                    k=k+1;
                    chkBit(ind)=-99;
                end
            else
                if count(nClasses)<numSamplesPerDigitPerFold
                    feature_fold(k,:)=feature(ind,:);
                    label_fold(k,1)=label(ind,1);
                    count(nClasses,1)=count(nClasses,1)+1;
                    k=k+1;
                    chkBit(ind)=-99;
                end
            end
        end
    end
    tempFeature=[tempFeature;feature_fold];
    tempLabel=[tempLabel;label_fold];
    curFold=curFold+1;
 %   input 'next'
end        
        
feature=tempFeature;
label=tempLabel;
[nSamples,nFeatures]=size(feature);  

 %%    
 fprintf('\n Starting Cross Validation and Parameter estimation')
 fprintf('\n Working...')
curTestFold=1;  
grid=[];
bestGrid=[];
foldTestAccuracy_matrix=[];
Opt_C=0;
Opt_G=0;
Max_Accuracy=0;
while curTestFold<=numFolds
    curTestFold_feature=feature(1+((curTestFold-1)*foldSize):(curTestFold*foldSize),:);
    curTestFold_label=label(1+((curTestFold-1)*foldSize):(curTestFold*foldSize),1);
    
    curTrainingFolds_feature=[feature(1:(curTestFold-1)*foldSize,:);feature(curTestFold*foldSize+1:end,:)];
    curTrainingFolds_label=[label(1:(curTestFold-1)*foldSize,1);label(curTestFold*foldSize+1:end,1)];  
    
    curValidSubFold=1;
    bestValid_Accuracy=0;
    bestValid_c=0;
    bestValid_g=0;
 %   input 'check 1, proceed?'
    fprintf('\n*******************************************')
    fprintf('\nCurrent Test Fold:%d',curTestFold);
    fprintf('\n*******************************************')
    while curValidSubFold<=numSubFolds
        fprintf('\n=============================================')
        fprintf('\nCurrent Validation Test SubFold:%d',curValidSubFold);
        fprintf('\n=============================================')
        curValid_TestFeature=curTrainingFolds_feature(1+((curValidSubFold-1)*foldSize):(curValidSubFold*foldSize),:);
        curValid_TestLabel=curTrainingFolds_label(1+((curValidSubFold-1)*foldSize):(curValidSubFold*foldSize),1);
        
        curValid_TrainingFeature=[curTrainingFolds_feature(1:(curValidSubFold-1)*foldSize,:);curTrainingFolds_feature(curValidSubFold*foldSize+1:end,:)];
        curValid_TrainingLabel=[curTrainingFolds_label(1:(curValidSubFold-1)*foldSize,1);curTrainingFolds_label(curValidSubFold*foldSize+1:end,1)];
        
        bestAccuracy = 0;
        bestc=0;
        bestg=0;
   %     input 'check 1.1, proceed?'
        p1=1;
        for log2c = 0:9,
            fprintf('\n--------------------------------')
            fprintf('\n Run %d \n',p1);
            fprintf('--------------------------------\n')
            p2=1;
            accuracy=0;
            for log2g = -10:-3,
                if accuracy<80 && accuracy~=0
                    continue;
                end
                fprintf('\n Run %d_%d \n',p1,p2);
                cmd = ['-c ', num2str(2^log2c), ' -g ', num2str(2^log2g),' -q'];
                model = svmtrain(curValid_TrainingLabel, curValid_TrainingFeature, cmd);
                [~, accuracy,~]=svmpredict(curValid_TestLabel,curValid_TestFeature,model);
                accuracy=accuracy(1,1);
                grid=[grid;accuracy 2^log2c 2^log2g];
                
                if (accuracy >= bestAccuracy),
                  bestAccuracy = accuracy; bestc = 2^log2c; bestg = 2^log2g;
                end
                fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, accuracy, bestc, bestg, bestAccuracy);
               
                p2=p2+1;
                
           end
        p1=p1+1;  
        end
        bestGrid=[bestGrid;bestAccuracy,bestc,bestg]; 
        if bestAccuracy>=bestValid_Accuracy
           bestValid_Accuracy= bestAccuracy;
           bestValid_c=bestc;
           bestValid_g=bestg;
        end
%        input 'check 2, proceed?'
        curValidSubFold=curValidSubFold+1;
    end
    
    % test on curTestFold
    cmd = ['-c ', num2str(bestValid_c), ' -g ', num2str(bestValid_g),' -q'];
    model = svmtrain(curTrainingFolds_label,curTrainingFolds_feature, cmd);
    [~, accuracy,~]=svmpredict(curTestFold_label,curTestFold_feature,model);
    accuracy=accuracy(1,1);
    foldTestAccuracy_matrix=[foldTestAccuracy_matrix;accuracy,bestValid_c,bestValid_g];
    if accuracy>=Max_Accuracy
        Max_Accuracy=accuracy;
        Opt_C=bestValid_c;
        Opt_G=bestValid_g;
    end
    curTestFold=curTestFold+1;
%    input 'check 3, proceed?'
end
fprintf('\n Cross Validation and Parameter Estimation done.')
%input 'check 4, proceed?'
estimatedAccuracy=sum(foldTestAccuracy_matrix(:,1))/size(foldTestAccuracy_matrix,1);
fprintf('\n The estimated error is : %.3f',estimatedAccuracy)
fprintf('\n Optimal C = %.4f',Opt_C)
fprintf('\n Optimal G = %.6f',Opt_G)
%input 'check 5, proceed?'
%%
fprintf('\n Now training on entire data set...\n')
load('D:\USC\Sem 2\Pattern Recoginition\Project\Padagog\Training Data\feature_train.mat');
load('D:\USC\Sem 2\Pattern Recoginition\Project\Padagog\Training Data\label_train.mat');
feature=zscore(feature);
cmd = ['-c ', num2str(Opt_C), ' -g ', num2str(Opt_G),' -q'];
model = svmtrain(label, feature, cmd);
load('D:\USC\Sem 2\Pattern Recoginition\Project\Padagog\Test Data\feature_test.mat');
load('D:\USC\Sem 2\Pattern Recoginition\Project\Padagog\Test Data\label_test.mat');
feature=zscore(feature);
fprintf('\nTesting the model\n')
[predicted_label, accuracy,~]=svmpredict(label,feature,model);
fprintf('\n Accuracy on Test Data : %.3f',accuracy(1,1));
fprintf('\n\n----DONE----\n');
        
    
