clc
clear
close all
load data1
load data2
load data3
load data4
load data5

Totaldata=[data1(:,1:5),data1(:,end);data2(:,1:5),data2(:,end);...
    data3(:,1:5),data3(:,end);data4(:,1:5),data4(:,end);...
    data5(:,1:5),data5(:,end)];

data=Totaldata(:,1:5);
target=Totaldata(:,6);
add0=find(Totaldata(:,end)==0);
data(add0,:)=[];
target(add0)=[];

num=[3:5];

Crushdata=Totaldata(Totaldata(:,6)==1,num)';
Normaldata=Totaldata(Totaldata(:,6)==2,num)';
Wedgedata=Totaldata(Totaldata(:,6)==3,num)';
BiConcavedata=Totaldata(Totaldata(:,6)==4,num)';
traindata=cell(4,1);
testdata=cell(4,1);

for iter=1:200
    %% classification
    % class1
    addr1=randperm(size(Crushdata,2));
    n1=round(size(Crushdata,2)*0.7);
    indxtrainA=addr1(1:n1);
    indxtestA=addr1(n1+1:end);
    traindata{1,1}=Crushdata(:,indxtrainA);
    testdata{1,1}=Crushdata(:,indxtestA);
    % class2
    addr2=randperm(size(Normaldata,2));
    n2=round(size(Normaldata,2)*0.7);
    indxtrainB=addr2(1:n2);
    indxtestB=addr2(n2+1:end);
    traindata{2,1}=Normaldata(:,indxtrainB);
    testdata{2,1}=Normaldata(:,indxtestB);
    % class3
    addr3=randperm(size(Wedgedata,2));
    n3=round(size(Wedgedata,2)*0.7);
    indxtrainC=addr3(1:n3);
    indxtestC=addr3(n3+1:end);
    traindata{3,1}=Wedgedata(:,indxtrainC);
    testdata{3,1}=Wedgedata(:,indxtestC);
    % class4
    addr4=randperm(size(BiConcavedata,2));
    n4=round(size(BiConcavedata,2)*0.7);
    indxtrainD=addr4(1:n4);
    indxtestD=addr4(n4+1:end);
    traindata{4,1}=BiConcavedata(:,indxtrainD);
    testdata{4,1}=BiConcavedata(:,indxtestD);
    
    [ accuracy(iter,:), specifity(iter,:),sensitivity(iter,:) ] = multinclassSVM( traindata,testdata );
end
%% step 1: deviding data into training and test
% train data
disp(['accuracy: ',num2str(mean(accuracy)),' %'])
disp(['sensitivity: ',num2str(mean(sensitivity)),' %'])
disp(['specifity: ',num2str(mean(specifity)),' %'])

disp(['accuracy: ',num2str(mean(accuracy(:))),' %'])
disp(['sensitivity: ',num2str(mean(sensitivity(:))),' %'])
disp(['specifity: ',num2str(mean(specifity(:))),' %'])

