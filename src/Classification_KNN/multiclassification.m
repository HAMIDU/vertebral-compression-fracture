clc
clear
close all
load mydata
Totaldata=[data1(:,1:5),data1(:,end);data2(:,1:5),data2(:,end);...
    data3(:,1:5),data3(:,end);data4(:,1:5),data4(:,end);...
    data5(:,1:5),data5(:,end)];

data=Totaldata(:,1:5);
target=Totaldata(:,6);
add0=find(Totaldata(:,end)==0);
data(add0,:)=[];
target(add0)=[];
num=[1,2,3,4];

Crushdata=Totaldata(Totaldata(:,6)==1,num)';
Normaldata=Totaldata(Totaldata(:,6)==2,num)';
Wedgedata=Totaldata(Totaldata(:,6)==3,num)';
BiConcavedata=Totaldata(Totaldata(:,6)==4,num)';
%% classification
traindata=cell(4,1);
testdata=cell(4,1);
% class1 
traindata{1,1}=Crushdata(:,1:8);
testdata{1,1}=Crushdata(:,9:end);
% class2 
traindata{2,1}=Normaldata(:,1:18);
testdata{2,1}=Normaldata(:,19:end);
% class3 
traindata{3,1}=Wedgedata(:,1:10);
testdata{3,1}=Wedgedata(:,11:end);
% class4 

traindata{4,1}=BiConcavedata(:,1:20);
testdata{4,1}=BiConcavedata(:,21:end);

% class5 
% traindata{5,1}=maindata5(:,1:70);
% testdata{5,1}=maindata5(:,71:end);

% % traindata1=[traindata{1,1},traindata{2,1},traindata{3,1},traindata{4,1},traindata{5,1}];
% % group=[ones(1,size(traindata{1,1},2)),2*ones(1,size(traindata{2,1},2)),...
% %     3*ones(1,size(traindata{3,1},2)),4*ones(1,size(traindata{4,1},2)),...
% %     5*ones(1,size(traindata{5,1},2))];
% % [eigenvec1] = FDA(traindata1,group,4);
% % % [~,eigenvec1]=MY_ICA(traindata1,m);
% % % class 1
% % traindata{1,1}=eigenvec1*traindata{1,1};
% % testdata{1,1}=eigenvec1*testdata{1,1};
% % % class 2
% % traindata{2,1}=eigenvec1*traindata{2,1};
% % testdata{2,1}=eigenvec1*testdata{2,1};
% % % class 3
% % traindata{3,1}=eigenvec1*traindata{3,1};
% % testdata{3,1}=eigenvec1*testdata{3,1};
% % % class 4
% % traindata{4,1}=eigenvec1*traindata{4,1};
% % testdata{4,1}=eigenvec1*testdata{4,1};
% % % class 5
% % traindata{5,1}=eigenvec1*traindata{5,1};
% % testdata{5,1}=eigenvec1*testdata{5,1};
[ accuracy, specifity,sensitivity ] = multinclassSVM( traindata,testdata );
%% step 1: deviding data into training and test
% train data
disp(['accuracy: ',num2str(mean(accuracy)),' %'])
disp(['sensitivity: ',num2str(mean(sensitivity)),' %'])
disp(['specifity: ',num2str(mean(specifity)),' %'])



