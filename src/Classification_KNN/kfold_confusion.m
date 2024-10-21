clc
clear
close all
warning off
load mydata
Totaldata=[data1;data2;data3;data4;data5];
%% missing data
addr=find(isnan(Totaldata(:,7))==1);
temp7=Totaldata(:,7);
temp7(addr)=[];
Totaldata(addr,7)=mean(temp7);

addr=find(isnan(Totaldata(:,9))==1);
temp9=Totaldata(:,9);
temp9(addr)=[];
Totaldata(addr,9)=mean(temp9);

num=[1:9];

Crushdata=Totaldata(Totaldata(:,end)==3,num)';
Normaldata=Totaldata(Totaldata(:,end)==0,num)';
Wedgedata=Totaldata(Totaldata(:,end)==1,num)';
BiConcavedata=Totaldata(Totaldata(:,end)==2,num)';
N=5;
perfomance=zeros(N,1);
CONFUSIONMATRIX=0;
% Normaldata=1
for iter=1:N
    testindex1=(iter-1)*(round(size(Crushdata,2)/5))+1:(iter-1)*(round(size(Crushdata,2)/5))+...
        (round(size(Crushdata,2)/5));
    trainindex1=1:size(Crushdata,2);
    trainindex1(testindex1)=[];
    traindata1=Crushdata(:,trainindex1);
    testdata1=Crushdata(:,testindex1);
    % class 2
    testindex2=(iter-1)*(round(size(Normaldata,2)/5))+1:(iter-1)*(round(size(Normaldata,2)/5))+...
        (round(size(Normaldata,2)/5));
    trainindex2=1:size(Normaldata,2);
    trainindex2(testindex2)=[];
    traindata2=Normaldata(:,trainindex2);
    testdata2=Normaldata(:,testindex2);
    
    % class3
    testindex3=(iter-1)*(round(size(Wedgedata,2)/5))+1:(iter-1)*(round(size(Wedgedata,2)/5))+...
        (round(size(Wedgedata,2)/5));
    trainindex3=1:size(Wedgedata,2);
    trainindex3(testindex3)=[];
    traindata3=Wedgedata(:,trainindex3);
    testdata3=Wedgedata(:,testindex3);
    
    % class4
    testindex4=(iter-1)*(round(size(BiConcavedata,2)/5))+1:(iter-1)*(round(size(BiConcavedata,2)/5))+...
        (round(size(BiConcavedata,2)/5));
    trainindex4=1:size(BiConcavedata,2);
    trainindex4(testindex4)=[];
    traindata4=BiConcavedata(:,trainindex4);
    testdata4=BiConcavedata(:,testindex4);
    
     
    labeltr=[ones(1,size(traindata1,2)),2*ones(1,size(traindata2,2)),...
             3*ones(1,size(traindata3,2)),4*ones(1,size(traindata4,2))];
         
    Xtrain=[traindata1,traindata2,traindata3,traindata4]';
    Xtest=[testdata1,testdata2,testdata3,testdata4]';
    labeltest=[ones(1,size(testdata1,2)),2*ones(1,size(testdata2,2)),...
        3*ones(1,size(testdata3,2)),4*ones(1,size(testdata4,2))];
    
        svmstruct=svmtrain(Xtrain',labeltr,'kernel_function','linear');
        class=svmclassify(svmstruct,Xtest');
%      class=knnclassify(Xtest,Xtrain,labeltr,9);
   

    acc(iter,:) = sum(labeltest'==class)/length(class)*100;
%     add1=find(labeltest==1);
%     add2=find(labeltest==2);
%     
%     m1=sum(class(add1)==1);
%     m2=sum(class(add2)==2);
%     n1=sum(labeltest==1);
%     n2=sum(labeltest==2);
%     
%     sens(iter,:) = m1/n1*100;
%     spec(iter,:) = m2/n2*100;
    C(:,:,iter) = confusionmat(class,labeltest);
    CONFUSIONMATRIX=confusionmat(class,labeltest)+CONFUSIONMATRIX;
    
end
disp(['perfomance: ',num2str(mean(acc)),'%'])
% disp(['Sensitivity: ',num2str(mean(sens)),'%'])
% disp(['Specificity: ',num2str(mean(spec)),'%'])
% TP=sum(C(1,1,1:end));
% FP=sum(C(1,2,1:end));
% FN=sum(C(2,1,1:end));
% TN=sum(C(2,2,1:end));
% 
% 
% CONFUSIONMATRIX=[TP,FP;FN,TN]
% C=C(:,:,1:end)
CONFUSIONMATRIX


