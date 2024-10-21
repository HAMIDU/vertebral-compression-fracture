clc
clear
close all
img=imread('005-01.png');
img=rgb2gray(img);
% origimg=img;
imshow(img)

img=imadjust(img,[0.28 0.6],[0.5 0.9]);
img = imsharpen(img,'Radius',2,'Amount',3);
figure
imshow(img)
origimg=im2double(img);
figure,imshow(origimg)

img=im2bw(img,0.51);
figure
% imshow(img)
img = bwareaopen(img,100);
se = strel('sphere',2);
dilatedimg = imdilate(img, se);
se = strel('disk',2);
img = imerode(dilatedimg, se);
img = bwareaopen(img,300);
imshow(img)
m=img;
% [y x]=ginput(2);
% m = zeros(size(img,1),size(img,2));          %-- create initial mask
% m(x(1):x(2),y(1):y(2)) = 1;
%% segmentation
figure
subplot(2,2,1); imshow(img); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = region_seg(img, m, 100); %-- Run segmentation
subplot(2,2,4);
% imshow()
imshow(seg,[]); title('Global Region-Based Segmentation');

[m,n]=find(seg==1);
figure
imshow(img,[])
hold on 
plot(n,m,'.r','linewidth',2)

% % se = strel('sphere',1);
% % segimg1 = imerode(seg, se);
% % segimg=seg-segimg1;
% % [m,n]=find(segimg==1);
% % figure
% % imshow(origimg,[])
% % hold on
% % plot(n,m,'.r','linewidth',2)

