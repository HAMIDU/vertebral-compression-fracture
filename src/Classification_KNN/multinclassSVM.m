function [ Perfomance, specifity,sensitivity] = multinclassSVM( traindata,testdata )
for i=1:size(traindata,1)
    sel=1:size(traindata,1);
    sel(i)=[];
    trainclass1=traindata{i,1};
    trainclass2=[traindata{sel(1),1},traindata{sel(2),1},traindata{sel(3),1}];
    trainDATA=[trainclass1,trainclass2];
    group=[ones(1,size(trainclass1,2)),2*ones(1,size(trainclass2,2))];
    % test data
    testclass1=testdata{i,1};
    testclass2=[testdata{sel(1),1},testdata{sel(2),1},testdata{sel(3),1}];
    testDATA=[testclass1,testclass2];
    svmstruct=svmtrain(trainDATA,group,'kernel_function','linear');
%     svmstruct=svmtrain(trainDATA,group,'kernel_function','quadratic');
%     svmstruct=svmtrain(trainDATA,group,'kernel_function','rbf'  );
    output=svmclassify(svmstruct,testDATA');
    num1=sum(output(1:size(testclass1,2))==1);
    num2=sum(output(size(testclass1,2)+1:end)==2);
    
    Perfomance(i)=(num1+num2) / size(testDATA,2)*100;
    specifity(i)=(num1) / size(testDATA,2)*100;
    sensitivity(i)=(num2) / size(testDATA,2)*100; 
end

