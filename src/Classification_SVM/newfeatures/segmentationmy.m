clc
clear
close all
img=imread('snapshotImage003.png');
img=rgb2gray(img);
origimg=img;
imshow(img)



img=imadjust(img,[0.28 0.6],[0.5 0.9]);
img = imsharpen(img,'Radius',5,'Amount',5);
figure
imshow(img)
% hy = fspecial('average',55);
% img = imfilter(double(img), hy, 'replicate');
% level=graythresh(img);
% img=im2bw(img,0.51);
% figure
% imshow(img)
origimg=im2double(img);
figure,imshow(origimg)

% % hy = fspecial('average',5);
% hy = fspecial('gaussian',5,0.1); 
% newimg = imfilter(double(origimg), hy, 'replicate');
% origimg =  newimg;
% figure,imshow(origimg)

img=im2bw(img,0.51);
figure
imshow(img)
m=img;
%% segmentation
figure
subplot(2,2,1); imshow(origimg); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = region_seg(origimg, m, 5); %-- Run segmentation
subplot(2,2,4);
% imshow()
imshow(seg,[]); title('Global Region-Based Segmentation');

[m,n]=find(seg==1);
figure
imshow(origimg,[])
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

