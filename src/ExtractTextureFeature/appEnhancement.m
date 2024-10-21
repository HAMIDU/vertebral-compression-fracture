clc
clear
close all
img=imread('1 (15).png');
img=rgb2gray(img);
% origimg=img;
imshow(img)

img=imadjust(img,[0.2 0.6],[0.5 0.9]);
img = imsharpen(img,'Radius',5,'Amount',5);
figure
imshow(img)
origimg=im2double(img);
% figure,imshow(origimg)

level=graythresh(origimg);
img=im2bw(origimg,0.72);
figure
imshow(img)
img = bwareaopen(img,50);
se = strel('sphere',2);
dilatedimg = imdilate(img, se);
se = strel('L',2);
img = imerode(dilatedimg, se);
img = bwareaopen(img,100);
imshow(img)
m=img;
% % [y x]=ginput(2);
% % m = zeros(size(img,1),size(img,2));          %-- create initial mask
% % m(x(1):x(2),y(1):y(2)) = 1;
% %% segmentation
% figure
% subplot(2,2,1); imshow(img); title('Input Image');
% subplot(2,2,2); imshow(m); title('Initialization');
% subplot(2,2,3); title('Segmentation');
% 
% seg = region_seg(img, m, 10); %-- Run segmentation
% subplot(2,2,4);
% % imshow()
% imshow(seg,[]); title('Global Region-Based Segmentation');
% 
% [m,n]=find(seg==1);
% figure
% imshow(img,[])
% hold on 
% plot(n,m,'.r','linewidth',2)
