clc,
clear,
close all,
%% Basic Image Enhancement and Analysis Techniques
% This example shows how to enhance an image as a preprocessing step before
% analysis. In this example, you correct the nonuniform background
% illumination and convert the image into a binary image so that you can
% perform analysis of the image foreground objects.
%% Step 1: Read the Image into the Workspace
% Read and display the grayscale image |rice.png|.
img2= imread('snapshotImage003.png');
img2=rgb2gray(img2);
imshow(img2)
img=im2double(img2);
[m,n]=size(img);
img=img(:)';
level=50;
L=level+1;
h=linspace(0,1,L);

for i=1:L-1
    h1=h(i);
    h2=h(i+1);
    addr1=(img>=h1);
    addr2=(img<h2);
    addr=addr1 .* addr2;
    addr=find(addr==1);
    img(addr)=i-1;
end
cimg=reshape(img,m,n);
figure(2)
imshowpair(img2,cimg,'montage')