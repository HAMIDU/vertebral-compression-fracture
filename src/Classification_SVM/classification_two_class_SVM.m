clc
clear
close all
load mydata
% Totaldata=[data1(:,1:5),data1(:,end);data2(:,1:5),data2(:,end);...
%     data3(:,1:5),data3(:,end);data4(:,1:5),data4(:,end);...
%     data5(:,1:5),data5(:,end)];
Totaldata=[data1;data2;data3;data4;data5];

num=[1:9];
data=Totaldata(:,num);
target=Totaldata(:,end);
%????????
% add0=find(Totaldata(:,end)==0);
% data(add0,:)=[];
% target(add0)=[];
%% missing data 
addr=find(isnan(Totaldata(:,7))==1);
temp7=Totaldata(:,7);
temp7(addr)=[];
Totaldata(addr,7)=mean(temp7);

addr=find(isnan(Totaldata(:,9))==1);
temp9=Totaldata(:,9);
temp9(addr)=[];
Totaldata(addr,9)=mean(temp9)
%% data normalizition
% data=data-repmat(mean(data,2),1,size(data,2));
% data=data./repmat(std(data')',1,size(data,2));

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

    svmstruct=svmtrain(Xtrain',labeltr,'kernel_function','linear');
    class=svmclassify(svmstruct,Xtest');
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





