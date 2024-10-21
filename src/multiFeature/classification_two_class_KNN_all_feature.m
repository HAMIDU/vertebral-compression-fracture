clc
clear
close all
load mydata
warning off
load('HIStfeatures.mat')
data11=reshape(HIStfeatures(:,1,1:25),256,25)';
data21=reshape(HIStfeatures(:,2,1:25),256,25)';
data31=reshape(HIStfeatures(:,3,1:25),256,25)';
data41=reshape(HIStfeatures(:,4,1:25),256,25)';
data51=reshape(HIStfeatures(:,5,1:25),256,25)';

TotaldataHis=[data11;data21;data31;data41;data51];
Totaldata=[data1;data2;data3;data4;data5];
%Totaldata=[data1(:,1:9),data1(:,end);data2(:,1:9),data2(:,end);...
 %   data3(:,1:9),data3(:,end);data4(:,1:9),data4(:,end);...
  %  data5(:,1:9),data5(:,end)];
%% missing data 
addr=find(isnan(Totaldata(:,7))==1);
temp7=Totaldata(:,7);
temp7(addr)=[];
Totaldata(addr,7)=mean(temp7);

addr=find(isnan(Totaldata(:,9))==1);
temp9=Totaldata(:,9);
temp9(addr)=[];
Totaldata(addr,9)=mean(temp9);
%% combine features



%% feature selection
% for i=1:size(TotaldataHis,2)-1
%     data=TotaldataHis(:,i);
%     [t(i),p(i)]=ttest(data);
% end
% [~,indx]=sort(p,'ascend');
% 
% indxx=indx(1:50);
Totaldata=[TotaldataHis(:,200:end),Totaldata];


num=[1:256-199+9];
data=Totaldata(:,num);
target=Totaldata(:,end);
% add0=find(Totaldata(:,end)==0);
% data(add0,:)=[];
% target(add0)=[];
%% data normalizition
data=data-repmat(mean(data,1),size(data,1),1);
data=data./repmat(std(data),size(data,1),1);

target(target~=0)=1;
data=data';
N=200;
perfomance=zeros(N,1);
for iter=1:N
    div=0.7;
    %% data division into train(70%) and test(30%) data
    indxA=randperm(size(data,2));
    n1=round(div*length(indxA));
    indxAtrain=indxA(1:n1);
    indxAtest=indxA(n1+1:end);
    Xtrain=data(:,indxAtrain);
    Xtest=data(:,indxAtest);
    labeltr=target(indxAtrain);
    labeltest=target(indxAtest); 
    class=knnclassify(Xtest',Xtrain',labeltr,11);
    
    acc(iter) = sum(labeltest==class)/length(class);
    add1=find(labeltest==1);
    add2=find(labeltest==0);
    
    m1=sum(class(add1)==1);
    m2=sum(class(add2)==0);
    n1=sum(labeltest==1);
    n2=sum(labeltest==0);
    
    sens(iter) = m1/n1;
    spec(iter) = m2/n2;

end
% A=isnan(spec);
% addnan=find(A==1);
% spec(addnan)=[];
% B=isnan(sens);
% addnan=find(B==1);
% sens(addnan)=[];

disp(['perfomance: ',num2str(mean(acc)*100),'%'])
disp(['Sensitivity: ',num2str(mean(sens)*100),'%'])
disp(['Specificity: ',num2str(mean(spec)*100),'%'])





