clc
clear
close all
img=imread('snapshotImage003.png');
img=rgb2gray(img);
origimg=img;
imshow(img)



img=imadjust(img,[0.28 0.8],[0.5 0.9]);
% hy = fspecial('average',55);
% img = imfilter(double(img), hy, 'replicate');
% level=graythresh(img);
img=im2bw(img,0.51);
figure
imshow(img)
% figure,imshow(img)
se = strel('sphere', 2);
%%
% Dilate the image.
dilatedI = imdilate(img,se);
%%
% erode the image.
se = strel('sphere', 3);
erodedI = imerode(dilatedI,se);
erodedI = bwareaopen(erodedI,1000);
figure
imshow(erodedI)


%%
% Dilate the image.
se = strel('sphere', 8);
dilatedI = imdilate(erodedI,se);
%%
% erode the image.
se = strel('sphere', 1);
erodedI = imerode(dilatedI,se);
figure
imshow(erodedI)

%%
% Dilate the image.
se = strel('sphere', 8);
dilatedI = imdilate(erodedI,se);
finalimg=dilatedI-erodedI;
figure
imshow(finalimg)

labeld=bwlabel(finalimg);
[m,n]=find(finalimg==1);
k=0;
for i=1:max(labeld(:))
    [r,c]=find(labeld==i);
    if max(c)<max(n)
        k=k+1;
        addr=sub2ind(size(labeld),r,c);
        labeld(addr)=0;
    else
        addr=sub2ind(size(labeld),r,c);
        labeld(addr)=1;        
    end
 
end
%%
% Dilate the image.
se = strel('sphere', 4);
dilatedI = imdilate(labeld,se);
%%
% erode the image.
se = strel('sphere',6);
labeld = imerode(dilatedI,se);
figure
imshow(labeld)
imgn=zeros(size(labeld));
for i=1:size(labeld,1);
    addr=find(labeld(i,:)==1);
    imgn(i,min(addr)-150:min(addr)-40)=1;
end
    
figure
imshow(imgn)
addr=find(imgn~=1);

origimg(addr)=0;
% hy = fspecial('average',15);
% origimg = imfilter((origimg), hy, 'replicate');
% w = 9;
% % w     = 9;       % bilateral filter half-width
% sigma = [3 0.1]; % bilateral filter standard deviations
%sigma = [0 0]; % bilateral filter standard deviations

% Apply bilateral filter to each image.
% origimg = bfilter2(im2double(origimg),w,sigma);

origimg=adapthisteq(origimg);
% T = adaptthresh(origimg, 1);
% % Convert image to binary image, specifying the threshold value.
% 
% BW = imbinarize(origimg,T);
figure,imshow(origimg)

%% kmeans clusstering
[numRows numCols]=size(origimg);
vecimg=origimg(:);
origimg2=origimg;
opts = statset('Display','final');
[labels,centers] = kmeans(vecimg,3,'Distance','sqeuclidean',...
    'Replicates',5,'Options',opts);
[mx,indx]=max(centers);
labels(labels~=indx)=0;
labels(labels==indx)=1;
m = reshape(labels,[numRows numCols]);

m = bwareaopen(m,300);
figure
imshow(m)

%% segmentation
subplot(2,2,1); imshow(origimg); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = region_seg(origimg, m, 10); %-- Run segmentation
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
imshow(origimg,[])
hold on
plot(n,m,'.r','linewidth',2)
