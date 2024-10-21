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
N=200;
perfomance=zeros(N,1);
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
%%
% Train an SVM classifier on the same sample data. Standardize the data.
%     resp = strcmp(labeltr,'0'); % resp = 1, if Y = 'b', or 0 if Y = 'g'
resp=(ones(1,length(labeltr))==labeltr');
mdlSVM = fitcsvm(Xtrain',resp,'Standardize',true,'KernelFunction','RBF');
%%linear kerner is default
% mdlSVM = fitcsvm(Xtrain',resp,'Standardize',true);
%%
% Compute the posterior probabilities (scores).
mdlSVM = fitPosterior(mdlSVM);
[~,score_svm] = resubPredict(mdlSVM);
[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(resp,score_svm(:,mdlSVM.ClassNames),'true');
plot(Xsvm,Ysvm,'linewidth',2)
hold on
ylabel('TP (true positive)')
xlabel('FP (false positive)')





