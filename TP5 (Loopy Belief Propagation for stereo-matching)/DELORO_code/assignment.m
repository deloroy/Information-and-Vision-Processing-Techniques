clear all;
close all;
img_left_path  = ['tsukuba', filesep, 'imL.png'];
img_right_path = ['tsukuba', filesep, 'imR.png'];
disparity_path = ['tsukuba', filesep, 'tsukuba-truedispL.png'];

% read ground truth disparity image
disparity = imread(disparity_path);
% read left and righ images
img_left  = imread(img_left_path);
img_right = imread(img_right_path);

figure(1); clf(1);
subplot(1,2,1);    imagesc(img_left);  colormap(gray); title('Left Image')
subplot(1,2,2);    imagesc(img_right); colormap(gray); title('Right Image')
figure(2); clf(2); imagesc(disparity); colormap(gray); title('Disparity Image - Ground Truth')

% pre-process images by converting them to single precision gray-scale and
% smoothing them with a gaussian kernel of sigma = 0.6
img_left  = convertToGray(img_left);
img_right = convertToGray(img_right);
% myfilter  = fspecial('gaussian',[7 7], 0.6);
myfilter  = gaussian_filter_7x7;
% img_left  = imfilter(single(img_left),  myfilter, 'replicate');
img_left  = conv2(single(img_left), myfilter, 'same');
% img_right = imfilter(single(img_right), myfilter, 'replicate');
img_right = conv2(single(img_right), myfilter, 'same');

% estimate the disparity map with the Max-Product Loopy Belief Propagation
% Algorithm
lambda = 10;
[disparity_est, energy] = stereo_belief_propagation(img_left, img_right, lambda);

figure(3); clf(3);
imagesc(disparity_est); colormap(gray);
title('Disparity Image');

figure(4); clf(4);
plot(1:length(energy),energy)
title('Energy per iteration')