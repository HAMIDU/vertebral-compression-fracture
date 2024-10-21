clear
close all
load mydata
warning off

labels=[data1(:,10),data2(:,10),data3(:,10),data4(:,10),data5(:,10)];

load HistogramFeatures

kk1=0;
kk2=0;
for i=1:25
    for k=1:5
        if labels(i,k)==0
            kk1=kk1+1;
            datat1(:,kk1)=HIStfeatures(:,k,i);
            
        else 
            kk2=kk2+1;
            datat2(:,kk2)=HIStfeatures(:,k,i);
        end
    end
end
%% missing data 
 addr=find(isnan(datat1(2,:))==1);
 temp7=datat1(2,:);
 temp7(addr)=[];
 datat1(2,addr)=mean(temp7);
 
 addr=find(isnan(datat2(2,:))==1);
 temp7=datat2(2,:);
 temp7(addr)=[];
 datat2(2,addr)=mean(temp7);
%%
data=[datat1,datat2];
target = [zeros(1,size(datat1,2)),ones(1,size(datat2,2))];

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
%     class=knnclassify(Xtest',Xtrain',labeltr,9);
     svmstruct = svmtrain(Xtrain',labeltr,'kernel_function','linear');
     class = svmclassify(svmstruct,Xtest');
    acc(iter) = sum(labeltest'==class)/length(class);
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









