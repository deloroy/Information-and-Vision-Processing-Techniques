addpath(fullfile(pwd,'mincut'));
close all;
clear all;

image           = imread('coins.png');
% load pre-labelled background and foreground image region masks
scribbles       = load('scribbles.mat');
background_mask = scribbles.background > 0; % pre-labeled background image region mask
foreground_mask = scribbles.foreground > 0; % pre-labeled foreground image region mask

[H,W] = size(image);
NumPixels = H*W; 

figure(1);
subplot(1,2,1); imagesc(image); colormap(gray); title('Image');
% draw pre-labelled image regions
pre_labeled_im_regions = image;
pre_labeled_im_regions(background_mask) = 0; 
pre_labeled_im_regions(foreground_mask) = 255;
subplot(1,2,2); imagesc(pre_labeled_im_regions); colormap(gray); title('Pre-labeled image regions');

im_bg = image(background_mask); % image region that is pre-labeled as background
im_fg = image(foreground_mask); % image region that is pre-labeled as foreground

%% ***************** TODO: define the unary potential *********************

% TODO step 1: Create pixel intensity histograms for the background and 
% foreground image regions (vectors im_bg and im_fg). For that purpose use
% the build-in imhist() matlab function or the provided 
% image_histogram_256() function

im_hist_bg = image_histogram_256(im_bg); 
im_hist_fg = image_histogram_256(im_fg); 

% TODO step 2: Normalize each histogram such that they sum to one 
% (i.e. sum(im_hist_bg) == 1.0) and thus represent valid probability 
% distributions. 

im_hist_bg /= sum(im_hist_bg);
im_hist_fg /= sum(im_hist_fg);

% The following code draws the probability distributions of the 
% labeled background and foreground image regions; necessay only for 
% debugging purposes)unary = zeros(2, NumPixels); % initialization of unary matrix; 

figure(2);
subplot(1,2,1); bar(im_hist_bg); 
title('Background pixel intensity probability distribution');
ylim([0, 0.15]); xlim([1, 256]);
subplot(1,2,2); bar(im_hist_fg); 
title('Foreground pixel intensity probability distribution');
ylim([0, 0.15]); xlim([1, 256]);

% TODO step 3: Given the pixel intensity probability distributions of the
% pre-labeled background image regions (im_hist_bg) and foreground image
% regions (im_hist_fg) define the unary potentials:
unary = zeros(2, NumPixels); % initialization of unary matrix; 
% Note: place on the 1st row unary(1,:) the background unary potentials and 
% on the second row unary(2,:) the foreground unary potentials

k=10**(-5);
image_vect=reshape(image,NumPixels,1);
unary(1,:)=-log(k+im_hist_bg(image_vect));
unary(2,:)=-log(k+im_hist_fg(image_vect));

% The following code estimates the image segmentation based solely on the
% unary potentials and draws the results; this part of the code is only 
% necessary for debugging purposes.
[minval, solution_labels_unaries] = min(unary,[], 1);
solution_labels_unaries = reshape(solution_labels_unaries, [H, W]);
figure(3); imagesc(solution_labels_unaries); colormap(gray); 
title('Image segmentation based only on the unary potentials');

%% ******************** TODO: define the edge weights *********************
edge_weights = sparse(NumPixels,NumPixels); % initialization of edge_weights sparse matrix

% TODO step 1: connect each pixel p=(x,y) with its up neighbor q=(x,y-1) 
% by setting the edge weight between p and q to 10.0.

[X,Y]=meshgrid(1:W,2:H);
X=X(:);
Y=Y(:);
p_north=(X-1)*H+Y;
q_north=(X-1)*H+Y-1;

% TODO step 2: connect each pixel p=(x,y) with its down neighbor q=(x,y+1) 
% by setting the edge weight between the p and q pixels to 10.0

[X,Y]=meshgrid(1:W,1:H-1);
X=X(:);
Y=Y(:);
p_south=(X-1)*H+Y;
q_south=(X-1)*H+Y+1;

% TODO step 3: connect each pixel p=(x,y) with its left neighbor q=(x+1,y) 
% by setting the edge weight between the p and q pixels to 10.0

[X,Y]=meshgrid(1:W-1,1:H);
X=X(:);
Y=Y(:);
p_east=(X-1)*H+Y;
q_east=X*H+Y;

% TODO step 4: connect each pixel p=(x,y) with its right neighbor q=(x-1,y) 
% by setting the edge weight between the p and q pixels to 10.0

[X,Y]=meshgrid(2:W,1:H);
X=X(:);
Y=Y(:);
p_west=(X-1)*H+Y;
q_west=(X-2)*H+Y;

p=[p_north', p_south', p_east', p_west'];
q=[q_north', q_south', q_east', q_west'];

edge_weights=sparse(p,q,10.0,NumPixels,NumPixels);

%% *************** TODO: define the pairwise potentials *******************
pairwise = zeros(2,2); % initialization of the pairwise matrix
BG = 1; % index of the background label
FG = 2; % index of the forground label
% TODO: set the pairwise cost for each of the possible label combinations; 
% the possible label combinations are (BG,BG), (BG, FG), (FG, BG), and 
% (FG, FG).
pairwise(BG,BG)=0.;
pairwise(BG,FG)=1.;
pairwise(FG,FG)=0.;
pairwise(FG,BG)=1.;

% The following code estimates the image segmentation based both on the
% unary and the pairwise potentials using mincut algorithn.
solution_labels = mrf_mincut(unary, edge_weights, pairwise);
solution_labels = reshape(solution_labels, H, W);

% draw the obtained solution
figure(4); imagesc( solution_labels ); colormap(gray); title('Image segmentation');

% draw the ground truth labels
ground_truth_labels = imread('coins_groundTruth.png');
figure(5); imagesc( ground_truth_labels); colormap(gray); title('Ground Truth Labels');

% TODO: compute accuracy

solution_labels_unaries = reshape(solution_labels_unaries, H, W)-1;
fprintf('Results only with the unary potentials \n');
accuracy1 = size(find(ground_truth_labels==solution_labels_unaries))(1)/NumPixels; 
fprintf('Accuracy (simple matching with ground truth) : %f', accuracy1);
fprintf('\n');
accuracy2 = size(intersect(find(ground_truth_labels==1),find(solution_labels_unaries==1)))(1)/size(union(find(ground_truth_labels==1),find(solution_labels_unaries==1)))(1);
fprintf('Accuracy (intersection over union) : %f', accuracy2);
fprintf('\n');
fprintf('\n');


fprintf('Results with the pairwise potentials \n');
accuracy1 = size(find(ground_truth_labels==solution_labels))(1)/NumPixels; 
fprintf('Accuracy (simple matching with ground truth) : %f', accuracy1);
fprintf('\n');
accuracy2 = size(intersect(find(ground_truth_labels==1),find(solution_labels==1)))(1)/size(union(find(ground_truth_labels==1),find(solution_labels==1)))(1);
fprintf('Accuracy (intersection over union) : %f', accuracy2);