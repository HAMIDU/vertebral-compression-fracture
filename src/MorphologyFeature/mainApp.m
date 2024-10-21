clc
clear 
close all
img=imread('mask-002-01.png');
% imshow(img)

img=rgb2gray(img);
origimg=img;
img= im2bw(img,graythresh(img));
se = strel('sphere', 2);
% erode the image.
erodedI = imerode(img,se);
img = imdilate(erodedI,se);
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

seg = region_seg(origimg, m, 280); %-- Run segmentation
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
% step 1: finding lumar address
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
title('L1')
subplot(3,2,2)
imshow(img2)
title('L2')
subplot(3,2,3)
imshow(img3)
title('L3')
subplot(3,2,4)
imshow(img4)
title('L4')
subplot(3,2,5)
imshow(img5)
title('L5')

%% step 2: extract featurs
[m1,n1]=find(imgn==1);
[m2,n2]=find(imgn==2);
[m3,n3]=find(imgn==3);
[m4,n4]=find(imgn==4);
[m5,n5]=find(imgn==5);

%% points of Lumbar 1
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

dis1_3 =  sqrt(([n1(indx31),m1(indx31)] - [n1(p12),m1(p12)]).^2);
p5 = [ m1(p12)+(dis1_3(2)/2),n1(p12) + (dis1_3(1)/2)];

p5=repmat(p5,length(m1),1);
distp51=sqrt( sum((tp'-p5').^2 ));
[~,indx51]=min(distp51);


dis2_2 =  sqrt(([n1(p11),m1(p11)] - [n1(indx41),m1(indx41)]).^2);
p6 = [ m1(indx41)+(dis2_2(2)/2),n1(indx41) + (dis2_2(1)/2)];

p6=repmat(p6,length(m1),1);
distp61=sqrt( sum((tp'-p6').^2 ));
[~,indx61]=min(distp61);

%% point 5 and 6
%% erosion 
se = strel('sphere', 2);
% erode the image.
erodedI = imerode(img1,se);
edgess=img1-erodedI;
figure,imshow(edgess)
[m11,n11]=find(edgess==1);
tpp=[m11,n11];
p5=repmat([m1(indx51),n1(indx51)],length(m11),1);
distp511=sqrt( sum((tpp'-p5').^2 ));
[~,indx511]=min(distp511);

p6=repmat([m1(indx61),n1(indx61)],length(m11),1);
distp611=sqrt( sum((tpp'-p6').^2 ));
[~,indx611]=min(distp611);


% end

figure 
imshow(img1)
hold on
plot(n1(p11),m1(p11),'ro','linewidth',2)
plot(n1(p12),m1(p12),'ro','linewidth',2)
plot(n1(indx31),m1(indx31),'ro','linewidth',2)
plot(n1(indx41),m1(indx41),'ro','linewidth',2)
plot(n11(indx511),m11(indx511),'ro','linewidth',2)
plot(n11(indx611),m11(indx611),'ro','linewidth',2)


point6=[n1(p11),m1(p11)];
point1=[n1(p12),m1(p12)];
point3=[n1(indx31),m1(indx31)];
point4=[n1(indx41),m1(indx41)];
point2=[n11(indx511),m11(indx511)];
point5=[n11(indx611),m11(indx611)];

featuresdisc1 = [ sqrt(sum( (point1-point4).^2));...
                  sqrt(sum( (point2-point5).^2));...
                  sqrt(sum( (point3-point6).^2))];

%% points of Lumbar 2
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

dis2_3 =  sqrt(([n2(indx32),m2(indx32)] - [n2(p22),m2(p22)]).^2);
p5 = [ m2(p22)+(dis2_3(2)/2),n2(p22) + (dis2_3(1)/2)];

p5=repmat(p5,length(m2),1);
distp52=sqrt( sum((tp'-p5').^2 ));
[~,indx52]=min(distp52);

dis2_2 =  sqrt(([n2(p21),m2(p21)] - [n2(indx42),m2(indx42)]).^2);
p6 = [ m2(indx42)+(dis2_2(2)/2),n2(indx42) + (dis2_2(1)/2)];

p6=repmat(p6,length(m2),1);
distp61=sqrt( sum((tp'-p6').^2 ));
[~,indx62]=min(distp61);

%% point 5 and 6
%% erosion 
se = strel('sphere', 2);
% erode the image.
erodedI = imerode(img2,se);
edgess=img2-erodedI;
% figure,imshow(edgess)
[m22,n22]=find(edgess==1);
tpp=[m22,n22];
p5=repmat([m2(indx52),n2(indx52)],length(m22),1);
distp522=sqrt( sum((tpp'-p5').^2 ));
[~,indx522]=min(distp522);

p6=repmat([m2(indx62),n2(indx62)],length(m22),1);
distp622=sqrt( sum((tpp'-p6').^2 ));
[~,indx622]=min(distp622);

figure 
imshow(img2)
hold on
plot(n2(p21),m2(p21),'ro','linewidth',2)
plot(n2(p22),m2(p22),'ro','linewidth',2)
plot(n2(indx32),m2(indx32),'ro','linewidth',2)
plot(n2(indx42),m2(indx42),'ro','linewidth',2)
plot(n22(indx522),m22(indx522),'ro','linewidth',2)
plot(n22(indx622),m22(indx622),'ro','linewidth',2)

point6=[n2(p21),m2(p21)];
point1=[n2(p22),m2(p22)];
point3=[n2(indx32),m2(indx32)];
point4=[n2(indx42),m2(indx42)];
point2=[n22(indx522),m22(indx522)];
point5=[n22(indx622),m22(indx622)];

featuresdisc2 = [ sqrt(sum( (point1-point4).^2));...
                  sqrt(sum( (point2-point5).^2));...
                  sqrt(sum( (point3-point6).^2))];



%% points of Lumbar 3
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

dis2_3 =  sqrt(([n3(indx33),m3(indx33)] - [n3(p32),m3(p32)]).^2);
p5 = [ m3(p32)+(dis2_3(2)/2),n3(p32) + (dis2_3(1)/2)];

p5=repmat(p5,length(m3),1);
distp52=sqrt( sum((tp'-p5').^2 ));
[~,indx53]=min(distp52);

dis2_2 =  sqrt(([n3(p31),m3(p31)] - [n3(indx43),m3(indx43)]).^2);
p6 = [ m3(indx43)+(dis2_2(2)/2),n3(indx43) + (dis2_2(1)/2)];

p6=repmat(p6,length(m3),1);
distp61=sqrt( sum((tp'-p6').^2 ));
[~,indx63]=min(distp61);
%% point 5 and 6
%% erosion 
se = strel('sphere', 2);
% erode the image.
erodedI = imerode(img3,se);
edgess=img3-erodedI;
 figure,imshow(edgess)
[m33,n33]=find(edgess==1);
tpp=[m33,n33];
p5=repmat([m3(indx53),n3(indx53)],length(m33),1);
distp533=sqrt( sum((tpp'-p5').^2 ));
[~,indx533]=min(distp533);

p6=repmat([m3(indx63),n3(indx63)],length(m33),1);
distp633=sqrt( sum((tpp'-p6').^2 ));
[~,indx633]=min(distp633);

figure 
imshow(img3)
hold on
plot(n3(p31),m3(p31),'ro','linewidth',2)
plot(n3(p32),m3(p32),'ro','linewidth',2)
plot(n3(indx33),m3(indx33),'ro','linewidth',2)
plot(n3(indx43),m3(indx43),'ro','linewidth',2)
plot(n3(indx53),m3(indx53),'ro','linewidth',2)
plot(n33(indx633),m33(indx633),'ro','linewidth',2)

point6=[n3(p31),m3(p31)];
point1=[n3(p32),m3(p32)];
point3=[n3(indx33),m3(indx33)];
point4=[n3(indx43),m3(indx43)];
point2=[n3(indx53),m3(indx53)];
point5=[n33(indx633),m33(indx633)];

featuresdisc3 = [ sqrt(sum( (point1-point4).^2));...
                  sqrt(sum( (point2-point5).^2));...
                  sqrt(sum( (point3-point6).^2))];



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
dis2_3 =  sqrt(([n4(indx34),m4(indx34)] - [n4(p42),m4(p42)]).^2);
p5 = [ m4(p42)+(dis2_3(2)/2),n4(p42) + (dis2_3(1)/2)];

p5=repmat(p5,length(m4),1);
distp52=sqrt( sum((tp'-p5').^2 ));
[~,indx54]=min(distp52);

dis2_2 =  sqrt(([n4(p41),m4(p41)] - [n4(indx44),m4(indx44)]).^2);
p6 = [ m4(indx44)+(dis2_2(2)/2),n4(indx44) + (dis2_2(1)/2)];

p6=repmat(p6,length(m4),1);
distp61=sqrt( sum((tp'-p6').^2 ));
[~,indx64]=min(distp61);

%% point 5 and 6
%% erosion 
se = strel('sphere', 2);
% erode the image.
erodedI = imerode(img4,se);
edgess=img4-erodedI;
% figure,imshow(edgess)
[m44,n44]=find(edgess==1);
tpp=[m44,n44];
p5=repmat([m4(indx54),n4(indx54)],length(m44),1);
distp544=sqrt( sum((tpp'-p5').^2 ));
[~,indx544]=min(distp544);

p6=repmat([m4(indx64),n4(indx64)],length(m44),1);
distp644=sqrt( sum((tpp'-p6').^2 ));
[~,indx644]=min(distp644);


figure 
imshow(img4)
hold on
plot(n4(p41),m4(p41),'ro','linewidth',2)
plot(n4(p42),m4(p42),'ro','linewidth',2)
plot(n4(indx34),m4(indx34),'ro','linewidth',2)
plot(n4(indx44),m4(indx44),'ro','linewidth',2)
plot(n44(indx544),m44(indx544),'ro','linewidth',2)
plot(n44(indx644),m44(indx644),'ro','linewidth',2)


point6=[n4(p41),m4(p41)];
point1=[n4(p42),m4(p42)];
point3=[n4(indx34),m4(indx34)];
point4=[n4(indx44),m4(indx44)];
point2=[n44(indx544),m44(indx544)];
point5=[n44(indx644),m44(indx644)];

featuresdisc4 = [ sqrt(sum( (point1-point4).^2));...
                  sqrt(sum( (point2-point5).^2));...
                  sqrt(sum( (point3-point6).^2))];

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

dis2_3 =  sqrt(([n5(indx35),m5(indx35)] - [n5(p52),m5(p52)]).^2);
p5 = [ m5(p52)+(dis2_3(2)/2),n5(p52) + (dis2_3(1)/2)];

p5=repmat(p5,length(m5),1);
distp52=sqrt( sum((tp'-p5').^2 ));
[~,indx55]=min(distp52);

dis2_2 =  sqrt(([n5(p51),m5(p51)] - [n5(indx45),m5(indx45)]).^2);
p6 = [ m5(indx45)+(dis2_2(2)/2),n5(indx45) + (dis2_2(1)/2)];

p6=repmat(p6,length(m5),1);
distp61=sqrt( sum((tp'-p6').^2 ));
[~,indx65]=min(distp61);
%% point 5 and 6
%% erosion 
se = strel('sphere', 2);
% erode the image.
erodedI = imerode(img5,se);
edgess=img5-erodedI;
% figure,imshow(edgess)
[m55,n55]=find(edgess==1);
tpp=[m55,n55];
p5=repmat([m5(indx55),n5(indx55)],length(m55),1);
distp555=sqrt( sum((tpp'-p5').^2 ));
[~,indx555]=min(distp555);

p6=repmat([m5(indx65),n5(indx65)],length(m55),1);
distp655=sqrt( sum((tpp'-p6').^2 ));
[~,indx655]=min(distp655);


figure 
imshow(img5)
hold on
plot(n5(p51),m5(p51),'ro','linewidth',2)
plot(n5(p52),m5(p52),'ro','linewidth',2)
plot(n5(indx35),m5(indx35),'ro','linewidth',2)
plot(n5(indx45),m5(indx45),'ro','linewidth',2)
plot(n55(indx555),m55(indx555),'ro','linewidth',2)
plot(n55(indx655),m55(indx655),'ro','linewidth',2)

point6=[n5(p51),m5(p51)];
point1=[n5(p52),m5(p52)];
point3=[n5(indx35),m5(indx35)];
point4=[n5(indx45),m5(indx45)];
point2=[n55(indx555),m55(indx555)];
point5=[n55(indx655),m55(indx655)];

featuresdisc5 = [ sqrt(sum( (point1-point4).^2));...
                  sqrt(sum( (point2-point5).^2));...
                  sqrt(sum( (point3-point6).^2))];

%% 
figure
imshow(origimg)
hold on
plot(n1(p11),m1(p11),'ro','linewidth',2)
plot(n1(p12),m1(p12),'ro','linewidth',2)
plot(n1(indx31),m1(indx31),'ro','linewidth',2)
plot(n1(indx41),m1(indx41),'ro','linewidth',2)
plot(n11(indx511),m11(indx511),'ro','linewidth',2)
plot(n11(indx611),m11(indx611),'ro','linewidth',2)

plot(n2(p21),m2(p21),'ro','linewidth',2)
plot(n2(p22),m2(p22),'ro','linewidth',2)
plot(n2(indx32),m2(indx32),'ro','linewidth',2)
plot(n2(indx42),m2(indx42),'ro','linewidth',2)
plot(n22(indx522),m22(indx522),'ro','linewidth',2)
plot(n22(indx622),m22(indx622),'ro','linewidth',2)

plot(n3(p31),m3(p31),'ro','linewidth',2)
plot(n3(p32),m3(p32),'ro','linewidth',2)
plot(n3(indx33),m3(indx33),'ro','linewidth',2)
plot(n3(indx43),m3(indx43),'ro','linewidth',2)
plot(n33(indx533),m33(indx533),'ro','linewidth',2)
plot(n33(indx633),m33(indx633),'ro','linewidth',2)

plot(n4(p41),m4(p41),'ro','linewidth',2)
plot(n4(p42),m4(p42),'ro','linewidth',2)
plot(n4(indx34),m4(indx34),'ro','linewidth',2)
plot(n4(indx44),m4(indx44),'ro','linewidth',2)
plot(n44(indx544),m44(indx544),'ro','linewidth',2)
plot(n44(indx644),m44(indx644),'ro','linewidth',2)

plot(n5(p51),m5(p51),'ro','linewidth',2)
plot(n5(p52),m5(p52),'ro','linewidth',2)
plot(n5(indx35),m5(indx35),'ro','linewidth',2)
plot(n5(indx45),m5(indx45),'ro','linewidth',2)
plot(n55(indx555),m55(indx555),'ro','linewidth',2)
plot(n55(indx655),m55(indx655),'ro','linewidth',2)

Feateures=[featuresdisc1,featuresdisc2,featuresdisc3,featuresdisc4,featuresdisc5];
% save featuresOfHeights featuresOfHeights
