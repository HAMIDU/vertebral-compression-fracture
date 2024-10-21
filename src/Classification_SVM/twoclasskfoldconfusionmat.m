clc
clear
close all
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
% %% feature selection
% for i=1:size(Totaldata,2)-1
%     data=Totaldata(:,i);
%     [t(i),p(i)]=ttest(data);
% end
% [~,indx]=sort(p,'descend');
% 
% num=indx(1:7);
load indexx

data=Totaldata(:,indexx(1:9));
target=Totaldata(:,end);
% add0=find(Totaldata(:,end)==0);
% data(add0,:)=[];
% target(add0)=[];

%% data normalizition
data=data-repmat(mean(data,2),1,size(data,2));
data=data./repmat(std(data')',1,size(data,2));
target(target~=0)=1;
data=data';

data1=data(:,target==0);
data1=data1(:,1:40);
data2=data(:,target==1);
data2=data2(:,1:80);
% target(target==0)=2;
N=10;
perfomance=zeros(N,1);

for iter=1:N
    testindex1=(iter-1)*(round(size(data1,2)/10))+1:(iter-1)*(round(size(data1,2)/10))+...
        (round(size(data1,2)/10));
    trainindex1=1:size(data1,2);
    trainindex1(testindex1)=[];
    traindata1=data1(:,trainindex1);
    testdata1=data1(:,testindex1);
    % class 2
    testindex2=(iter-1)*(round(size(data2,2)/10))+1:(iter-1)*(round(size(data2,2)/10))+...
        (round(size(data2,2)/10));
    trainindex2=1:size(data2,2);
    trainindex2(testindex2)=[];
    traindata2=data2(:,trainindex2);
    testdata2=data2(:,testindex2);
    labeltr=[ones(1,size(traindata1,2)),2*ones(1,size(traindata2,2))];
    Xtrain=[traindata1,traindata2];
    Xtest=[testdata1,testdata2];
    labeltest=[ones(1,size(testdata1,2)),2*ones(1,size(testdata2,2))];
    
    svmstruct=svmtrain(Xtrain',labeltr,'kernel_function','quadratic');
    class=svmclassify(svmstruct,Xtest');
%     
    class=knnclassify(Xtest',Xtrain',labeltr,7);
        
    acc(iter,:) = sum(labeltest'==class)/length(class)*100;
    add1=find(labeltest==1);
    add2=find(labeltest==2);
    
    m1=sum(class(add1)==1);
    m2=sum(class(add2)==2);
    n1=sum(labeltest==1);
    n2=sum(labeltest==2);
    
    sens(iter,:) = m1/n1*100;
    spec(iter,:) = m2/n2*100;
    C(:,:,iter) = confusionmat(class,labeltest);
    
end
disp(['perfomance: ',num2str(mean(acc)),'%'])
disp(['Sensitivity: ',num2str(mean(sens)),'%'])
disp(['Specificity: ',num2str(mean(spec)),'%'])
TP=sum(C(1,1,1:end));
FP=sum(C(1,2,1:end));
FN=sum(C(2,1,1:end));
TN=sum(C(2,2,1:end));


CONFUSIONMATRIX=[TP,FP;FN,TN]



