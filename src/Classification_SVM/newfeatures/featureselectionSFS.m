clc
clear
close all
load mydata
Totaldata=[data1(:,1:9),data1(:,end);data2(:,1:9),data2(:,end);...
    data3(:,1:9),data3(:,end);data4(:,1:9),data4(:,end);...
    data5(:,1:9),data5(:,end)];
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
% num=indx(1:4);
numm=[1:9];
dataA=Totaldata(:,numm);
target=Totaldata(:,end);
target(target~=0)=1;

indx1=find(target==1);
indx2=find(target==0);
maindata1 = dataA(indx1,:);
maindata2 = dataA(indx2,:);
data{1,1}=maindata1';
data{2,1}=maindata2';
% data{3,1}=maindata3;
%% forward feature extraction
tic
band=1:9;
sell=[];
kp=0;
while numel(band)~=0
    for f_num=band
        kp=kp+1;
        for class_num=1:1
            sel=1:2;
            class1=data{class_num,1};
            sel(class_num)=[];
            class2=[];
            for i=sel
                class2=[class2,data{i,1}];
            end
            num=60;
            Group=[-ones(1,num),ones(1,30)];
            FeatureTrain=[class1(:,1:num),class2(:,1:30)]';
            FeatureTest=[class1(:,num+1:end),class2(:,30+1:end)]';
            lanbeltrue=[-ones(1,size(class1(:,num+1:end),2)),ones(1,size(class2(:,30+1:end),2))];
            
            Utrain=FeatureTrain(:,[sell,f_num]);
            Dtrain=Group;
            Utest=FeatureTest(:,[sell,f_num]);
            Dtest=lanbeltrue;
            group=Dtrain;
            training=Utrain;
            sample = Utest;
            %             class = knnclassify(sample, training, group,5);
            svmstruct = svmtrain(training,group,'kernel_function','rbf');
            class = svmclassify(svmstruct,sample);
            a=(class'==Dtest);
            perf(class_num)=sum(a) /numel(a)  *100;
%             Mdl = fitcknn(training,group,'NumNeighbors',10);
%             rloss(i) = resubLoss(Mdl);
        end
        perff(kp)=mean(perf);
    end
    
    [~,id]=sort(perff,'descend');
%     idx(id(1))=[];
    sell=[sell,band(id(1))];
    band(id(1))=[];
    kp=0;
    perff=[];
end
toc
indexx=sell;
save indexx indexx
%% Elapsed time is 98.364903 seconds.

