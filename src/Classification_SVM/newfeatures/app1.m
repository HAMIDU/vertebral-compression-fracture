clc
clear
close all
img=imread('snapshotImage003.png');
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