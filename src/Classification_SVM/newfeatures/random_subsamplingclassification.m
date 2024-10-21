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

num=[4:9];

Crushdata=Totaldata(Totaldata(:,end)==3,num)';
Normaldata=Totaldata(Totaldata(:,end)==0,num)';
Wedgedata=Totaldata(Totaldata(:,end)==1,num)';
BiConcavedata=Totaldata(Totaldata(:,end)==2,num)';
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
% %     iter
end
%% step 1: deviding data into training and test
% train data
disp(['accuracy: ',num2str(mean(accuracy)),' %'])
disp(['sensitivity: ',num2str(mean(sensitivity)),' %'])
disp(['specifity: ',num2str(mean(specifity)),' %'])

disp(['accuracy: ',num2str(mean(accuracy(:))),' %'])
disp(['sensitivity: ',num2str(mean(sensitivity(:))),' %'])
disp(['specifity: ',num2str(mean(specifity(:))),' %'])

