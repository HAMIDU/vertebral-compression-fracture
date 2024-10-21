% Region Based Active Contour Segmentation
%
% seg = region_seg(I,init_mask,max_its,alpha,display)
%
% Inputs: I           2D image
%         init_mask   Initialization (1 = foreground, 0 = bg)
%         max_its     Number of iterations to run segmentation for
%         alpha       (optional) Weight of smoothing term
%                       higer = smoother.  default = 0.2
%         display     (optional) displays intermediate outputs
%                       default = true
%
% Outputs: seg        Final segmentation mask (1=fg, 0=bg)
%
% Description: This code implements the paper: "Active Contours Without
% Edges" By Chan Vese. This is a nice way to segment images whose
% foregrounds and backgrounds are statistically different and homogeneous.
%
% Example:
% img = imread('tire.tif');
% m = zeros(size(img));
% m(33:33+117,44:44+128) = 1;
% seg = region_seg(img,m,500);
%
% Coded by: Shawn Lankton (www.shawnlankton.com)
%------------------------------------------------------------------------
function seg = region_seg(I,init_mask,max_its,alpha,display)
  
  %-- default value for parameter alpha is .1
  if(~exist('alpha','var')) 
    alpha = .2; 
  end
  %-- default behavior is to display intermediate outputs
  if(~exist('display','var'))
    display = true;
  end
  %-- ensures image is 2D double matrix
  I = im2graydouble(I);    
  
  %-- Create a signed distance map (SDF) from mask
  phi = mask2phi(init_mask);
  
  %--main loop
  for its = 1:max_its   % Note: no automatic convergence test

    idx = find(phi <= 1.2 & phi >= -1.2);  %get the curve's narrow band
    
    %-- find interior and exterior mean
    upts = find(phi<=0);                 % interior points
    vpts = find(phi>0);                  % exterior points
    u = sum(I(upts))/(length(upts)+eps); % interior mean
    v = sum(I(vpts))/(length(vpts)+eps); % exterior mean
    
    F = (I(idx)-u).^2-(I(idx)-v).^2;         % force from image information
    curvature = get_curvature(phi,idx);  % force from curvature penalty
    
    dphidt = F./max(abs(F)) + alpha*curvature;  % gradient descent to minimize energy
    
    %-- maintain the CFL condition
    dt = .45/(max(dphidt)+eps);
        
    %-- evolve the curve
    phi(idx) = phi(idx) + dt.*dphidt;

    %-- Keep SDF smooth
    phi = sussman(phi, .5);

    %-- intermediate output
    if((display>0)&&(mod(its,20) == 0)) 
      showCurveAndPhi(I,phi,its);  
    end
  end
  
  %-- final output
  if(display)
    showCurveAndPhi(I,phi,its);
  end
  
  %-- make mask from SDF
  seg = phi<=0; %-- Get mask from levelset

  