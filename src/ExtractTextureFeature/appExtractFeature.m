clc,
clear,
close all,
%% benign

for i=1:25
    addr=['1 (',num2str(i),').png'];
    img=rgb2gray(imread(addr));
    img= im2double(img);
    imshow(img)
    for k=1:5
        ROI = imcrop(img);
        glcm = graycomatrix(ROI);
        stats = graycoprops(glcm);
        TXfeaturs(:,k,i) = [stats.Contrast;stats.Correlation;stats.Energy;stats.Homogeneity];
        HIStfeatures(:,k,i) = imhist(ROI);
        figure,area(HIStfeatures(:,k,i))
    end
end
% save Histogramfeatures HIStfeatures
% save TextureFeatures TXfeaturs