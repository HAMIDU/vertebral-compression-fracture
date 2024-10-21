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

traindata=cell(4,1);
testdata=cell(4,1);

for iter=1:200
    % classification
    % class1
    addr1=randperm(size(Crushdata,2));
    n1=round(size(Crushdata,2)*0.7);
    indxtrainA=addr1(1:n1);
    indxtestA=addr1(n1+1:end);
    traindata{1,1}=Crushdata(:,indxtrainA);
    testdata{1,1}=Crushdata(:,indxtestA);
    traindataknn1=Crushdata(:,indxtrainA);
    testdataknn1=Crushdata(:,indxtestA);
    % class2
    addr2=randperm(size(Normaldata,2));
    n2=round(size(Normaldata,2)*0.7);
    indxtrainB=addr2(1:n2);
    indxtestB=addr2(n2+1:end);
    traindata{2,1}=Normaldata(:,indxtrainB);
    testdata{2,1}=Normaldata(:,indxtestB);
    
    traindataknn2=Normaldata(:,indxtrainB);
    testdataknn2=Normaldata(:,indxtestB);
    % class3
    addr3=randperm(size(Wedgedata,2));
    n3=round(size(Wedgedata,2)*0.7);
    indxtrainC=addr3(1:n3);
    indxtestC=addr3(n3+1:end);
    traindata{3,1}=Wedgedata(:,indxtrainC);
    testdata{3,1}=Wedgedata(:,indxtestC);
    
    traindataknn3=Wedgedata(:,indxtrainC);
    testdataknn3=Wedgedata(:,indxtestC);
    % class4
    addr4=randperm(size(BiConcavedata,2));
    n4=round(size(BiConcavedata,2)*0.7);
    indxtrainD=addr4(1:n4);
    indxtestD=addr4(n4+1:end);
    traindata{4,1}=BiConcavedata(:,indxtrainD);
    testdata{4,1}=BiConcavedata(:,indxtestD); 
    
    traindataknn4=BiConcavedata(:,indxtrainD);
    testdataknn4=BiConcavedata(:,indxtestD); 
    
    TotalTrainData=[traindataknn1,traindataknn2,traindataknn3,traindataknn4];
    group=[ones(1,size(traindataknn1,2)),2*ones(1,size(traindataknn2,2)),3*ones(1,size(traindataknn3,2)),...
           4*ones(1,size(traindataknn4,2))];
    
    TotalTestData=[  testdataknn1,  testdataknn2,  testdataknn3,  testdataknn4];
    testlabel=[ones(1,size(testdataknn1,2)),2*ones(1,size(testdataknn2,2)),3*ones(1,size(testdataknn3,2)),...
           4*ones(1,size(testdataknn4,2))];
    %KNN   
    class=knnclassify(TotalTestData',TotalTrainData',group,9);
    accuracyknn(iter)=sum(class==testlabel')/numel(testlabel)*100;
    % ?????????????????
    add1=find(testlabel==1);
    add2=find(testlabel==2);
    % ?????????????????
    m1=sum(class(add1)==1);
    m2=sum(class(add2)==2);
    n1=sum(testlabel==1);
    n2=sum(testlabel==2);
    % ?????????????????
    sensknn(iter,:) = m1/n1*100;
    specknn(iter,:) = m2/n2*100;
    % ?????????????????
    %SVM
    [ accuracy(iter,:), specifity(iter,:),sensitivity(iter,:) ] = multinclassSVM( traindata,testdata );
        iter
end

%SVM
disp(['accuracySVM: ',num2str(mean(mean(accuracy))),' %'])
disp(['sensitivitySVM: ',num2str(mean(sensitivity)),' %'])
disp(['specifitySVM: ',num2str(mean(specifity)),' %'])

%KNN
disp(['accuracyKNN: ',num2str(mean(accuracyknn)),' %'])
disp(['sensitivityKNN: ',num2str(mean(sensknn)),' %'])
disp(['specifityKNN: ',num2str(mean(specknn)),' %'])