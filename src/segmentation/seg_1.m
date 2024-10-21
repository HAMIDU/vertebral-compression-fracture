clc;
clear;
close all;
img=imread('snapshotImage003.png');
img=im2double(rgb2gray(img));
img2=img;
figure
imshow((img),[])
% %% step 2: kmeans clusterring
% [numRows numCols]=size(img);
% vecimg=img(:);
% origimg2=img;
% opts = statset('Display','final');
% [lebels,centers] = kmeans(vecimg,4,'Distance','sqeuclidean',...
%     'Replicates',5,'Options',opts);
% img = reshape(lebels,[numRows numCols]);
% 
% figure
% imshow(img,[])
imshow(img2)
% title('T1 image')
hold on
[x y]=ginput(2);
m = zeros(size(img,1),size(img,2));          %-- create initial mask
m(x(1):x(2),y(1):y(2)) = 1;
subplot(2,2,1); imshow(img); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = region_seg(img, m, 50); %-- Run segmentation
subplot(2,2,4);
% imshow()
imshow(seg,[]); title('Global Region-Based Segmentation');

ROIadd=find(seg==1);
% intes=(origimg2(ROIadd));
% h1_1_=origimg2(ROIadd);
% h1_1=h1_1(:);
% h1_1=[h1_1];
% save h_1 h1_1
% figure
% bar(h1_1)
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
imshow(img2,[])
hold on
plot(n,m,'.r','linewidth',2)