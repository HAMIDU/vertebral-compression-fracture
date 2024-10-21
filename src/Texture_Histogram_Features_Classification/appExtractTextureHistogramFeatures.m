clc,
% clear,
close all,
% load TextureFeaturs 
% load HistogramFeatures
%% benign

for i=21:25
    addr=['1 (',num2str(i),').png'];
    img=rgb2gray(imread(addr));
    img= im2double(img);
    imshow(img)
    for k=1:5
        ROI = imcrop(img);
        glcm = graycomatrix(ROI);
        stats = graycoprops(glcm);
        TextureFeaturs(:,k,i) = [stats.Contrast;stats.Correlation;stats.Energy;stats.Homogeneity];
        HistogramFeatures(:,k,i) = imhist(ROI);
       % figure,area(HIStfeatures(:,k,i))
    end
end
% save TextureFeaturs TextureFeaturs
% save HistogramFeatures HistogramFeatures
