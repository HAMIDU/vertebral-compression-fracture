clc
clear 
close all
addpath('/activcontour/');
img=imread('mask-002-01.png');
% imshow(img)

img=rgb2gray(img);
origimg=img;
img= im2bw(img,graythresh(img));
imshow(img)
% m=imcrop(img);
hold on
[y x]=ginput(2);
m = zeros(size(img,1),size(img,2)); 
m(x(1):x(2),y(1):y(2)) = 1;
figure
imshow(m)
figure
%% segmentation
subplot(2,2,1); imshow(origimg); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = region_seg(origimg, m, 200); %-- Run segmentation
subplot(2,2,4);
% imshow()
imshow(seg,[]); title('Global Region-Based Segmentation');

ROIadd=find(seg==1);
notROIadd=find(seg~=1);
img(notROIadd)=0;
origimg(notROIadd)=0;

[m,n]=find(seg==1);
figure
imshow(img,[])
hold on 
plot(n,m,'.r','linewidth',2)

se = strel('sphere',1);
segimg1 = imerode(seg, se);
segimg=seg-segimg1;
[m,n]=find(segimg==1);
figure
imshow(origimg,[])
hold on
plot(n,m,'.r','linewidth',2)

%% feateure extraction
% step 1: finding discs address
labels=bwlabel(img);
[m1,n1]=find(labels==1);
[m2,n2]=find(labels==2);
[m3,n3]=find(labels==3);
[m4,n4]=find(labels==4);
[m5,n5]=find(labels==5);

[~,indx]=sort([min(m1),min(m2),min(m3),min(m4),min(m5)]);

add1=find(labels==indx(1));
imgn=zeros(size(img));
imgn(add1)=1;
add2=find(labels==indx(2));
imgn(add2)=2;
add3=find(labels==indx(3));
imgn(add3)=3;
add4=find(labels==indx(4));
imgn(add4)=4;
add5=find(labels==indx(5));
imgn(add5)=5;


addr1=find(imgn~=1);
img1=img;
img1(addr1)=0;

addr2=find(imgn~=2);
img2=img;
img2(addr2)=0;

addr3=find(imgn~=3);
img3=img;
img3(addr3)=0;

addr4=find(imgn~=4);
img4=img;
img4(addr4)=0;

addr5=find(imgn~=5);
img5=img;
img5(addr5)=0;


figure 
subplot(3,2,1)
imshow(img1)
title('disc 1')
subplot(3,2,2)
imshow(img2)
title('disc 2')
subplot(3,2,3)
imshow(img3)
title('disc 3')
subplot(3,2,4)
imshow(img4)
title('disc 4')
subplot(3,2,5)
imshow(img5)
title('disc 5')

%% step 2: extract featurs
[m1,n1]=find(imgn==1);
[m2,n2]=find(imgn==2);
[m3,n3]=find(imgn==3);
[m4,n4]=find(imgn==4);
[m5,n5]=find(imgn==5);

%% points of disk 1
dis1=(m1+n1).^2;
[~,p11]=max(dis1);
[~,p12]=min(dis1);

[~,p131]=min(m1);
[~,p132]=max(n1);
[~,p141]=max(m1);
[~,p142]=min(n1);
% for i=1:length(m1)
%     tp=[m1(i),n1(i)];
tp=[m1,n1];
point31=repmat([m1(p131),n1(p132)],length(m1),1);
distp31=sqrt( sum((tp'-point31').^2 ));
[~,indx31]=min(distp31);

point41=repmat([m1(p141),n1(p142)],length(m1),1);
distp41=sqrt( sum((tp'-point41').^2 ));
[~,indx41]=min(distp41);

% end

figure 
imshow(img1)
hold on
plot(n1(p11),m1(p11),'ro','linewidth',2)
plot(n1(p12),m1(p12),'ro','linewidth',2)
plot(n1(indx31),m1(indx31),'ro','linewidth',2)
plot(n1(indx41),m1(indx41),'ro','linewidth',2)


%% points of disk 2
dis2=(m2+n2).^2;
[~,p21]=max(dis2);
[~,p22]=min(dis2);

[~,p231]=min(m2);
[~,p232]=max(n2);
[~,p241]=max(m2);
[~,p242]=min(n2);
% for i=1:length(m1)
%     tp=[m1(i),n1(i)];
tp=[m2,n2];
point32=repmat([m2(p231),n2(p232)],length(m2),1);
distp32=sqrt( sum((tp'-point32').^2 ));
[~,indx32]=min(distp32);

point42=repmat([m2(p241),n2(p242)],length(m2),1);
distp42=sqrt( sum((tp'-point42').^2 ));
[~,indx42]=min(distp42);

% end

figure 
imshow(img2)
hold on
plot(n2(p21),m2(p21),'ro','linewidth',2)
plot(n2(p22),m2(p22),'ro','linewidth',2)
plot(n2(indx32),m2(indx32),'ro','linewidth',2)
plot(n2(indx42),m2(indx42),'ro','linewidth',2)

%% points of disk 3
dis3=(m3+n3).^2;
[~,p31]=max(dis3);
[~,p32]=min(dis3);

[~,p331]=min(m3);
[~,p332]=max(n3);
[~,p341]=max(m3);
[~,p342]=min(n3);
% for i=1:length(m1)
%     tp=[m1(i),n1(i)];
tp=[m3,n3];
point33=repmat([m3(p331),n3(p332)],length(m3),1);
distp33=sqrt( sum((tp'-point33').^2 ));
[~,indx33]=min(distp33);

point43=repmat([m3(p341),n3(p342)],length(m3),1);
distp43=sqrt( sum((tp'-point43').^2 ));
[~,indx43]=min(distp43);

% end

figure 
imshow(img3)
hold on
plot(n3(p31),m3(p31),'ro','linewidth',2)
plot(n3(p32),m3(p32),'ro','linewidth',2)
plot(n3(indx33),m3(indx33),'ro','linewidth',2)
plot(n3(indx43),m3(indx43),'ro','linewidth',2)


%% points of disk 4
dis4=(m4+n4).^2;
[~,p41]=max(dis4);
[~,p42]=min(dis4);

[~,p431]=min(m4);
[~,p432]=max(n4);
[~,p441]=max(m4);
[~,p442]=min(n4);
% for i=1:length(m1)
%     tp=[m1(i),n1(i)];
tp=[m4,n4];
point34=repmat([m4(p431),n4(p432)],length(m4),1);
distp34=sqrt( sum((tp'-point34').^2 ));
[~,indx34]=min(distp34);

point44=repmat([m4(p441),n4(p442)],length(m4),1);
distp44=sqrt( sum((tp'-point44').^2 ));
[~,indx44]=min(distp44);

% end

figure 
imshow(img4)
hold on
plot(n4(p41),m4(p41),'ro','linewidth',2)
plot(n4(p42),m4(p42),'ro','linewidth',2)
plot(n4(indx34),m4(indx34),'ro','linewidth',2)
plot(n4(indx44),m4(indx44),'ro','linewidth',2)



%% points of disk 5
dis5=(m5+n5).^2;
[~,p51]=max(dis5);
[~,p52]=min(dis5);

[~,p531]=min(m5);
[~,p532]=max(n5);
[~,p541]=max(m5);
[~,p542]=min(n5);
% for i=1:length(m1)
%     tp=[m1(i),n1(i)];
tp=[m5,n5];
point35=repmat([m5(p531),n5(p532)],length(m5),1);
distp35=sqrt( sum((tp'-point35').^2 ));
[~,indx35]=min(distp35);

point45=repmat([m5(p541),n5(p542)],length(m5),1);
distp45=sqrt( sum((tp'-point45').^2 ));
[~,indx45]=min(distp45);

% end
figure 
imshow(img5)
hold on
plot(n5(p51),m5(p51),'ro','linewidth',2)
plot(n5(p52),m5(p52),'ro','linewidth',2)
plot(n5(indx35),m5(indx35),'ro','linewidth',2)
plot(n5(indx45),m5(indx45),'ro','linewidth',2)
%% 
figure
imshow(origimg)
hold on
plot(n1(p11),m1(p11),'ro','linewidth',2)
plot(n1(p12),m1(p12),'ro','linewidth',2)
plot(n1(indx31),m1(indx31),'ro','linewidth',2)
plot(n1(indx41),m1(indx41),'ro','linewidth',2)

plot(n2(p21),m2(p21),'ro','linewidth',2)
plot(n2(p22),m2(p22),'ro','linewidth',2)
plot(n2(indx32),m2(indx32),'ro','linewidth',2)
plot(n2(indx42),m2(indx42),'ro','linewidth',2)

plot(n3(p31),m3(p31),'ro','linewidth',2)
plot(n3(p32),m3(p32),'ro','linewidth',2)
plot(n3(indx33),m3(indx33),'ro','linewidth',2)
plot(n3(indx43),m3(indx43),'ro','linewidth',2)

plot(n4(p41),m4(p41),'ro','linewidth',2)
plot(n4(p42),m4(p42),'ro','linewidth',2)
plot(n4(indx34),m4(indx34),'ro','linewidth',2)
plot(n4(indx44),m4(indx44),'ro','linewidth',2)

plot(n5(p51),m5(p51),'ro','linewidth',2)
plot(n5(p52),m5(p52),'ro','linewidth',2)
plot(n5(indx35),m5(indx35),'ro','linewidth',2)
plot(n5(indx45),m5(indx45),'ro','linewidth',2)




