%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TP1: Canny edge detection and Bilateral filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if you are not familiar with matlab, look at intro.m first.

%% 1. Beginning with Matlab

% Read and show an image
Irgb = imread('images/tools.jpg'); % read the image
% Images are read as matrix, Irgb(2,1,1) means the red channel of Irgb at x=1,y=2
[h,w,c]=size(Irgb);
fprintf('The size of Irgb is %i x %i x %i of type %s \n',h,w,c,class(Irgb));
fprintf('Its values are between %i and %i \n',min(Irgb(:)), max(Irgb(:)));
Irgb=double(Irgb)./255;
fprintf('Irgb is now of type %s \n',class(Irgb));
fprintf('Its values are between %i and %i \n\n',min(Irgb(:)), max(Irgb(:)));

I=get_luminance(Irgb); % convert the color image into grayscale
[h,w,c]=size(I);
fprintf('The size of I is %i x %i x %i of type %s \n',h,w,c,class(I));
fprintf('Its values are between %i and %i \n\n',min(I(:)), max(I(:)));

figure(1); % open a new figure with the handle 1
subplot(1,2,1); % divide the figure into a 1x2 array and use the first cell
imagesc(Irgb);
axis image off;
title('Image RGB'); % add a title to the first cell
subplot(1,2,2); % use the second cell
imagesc(I);
colormap(gray);
axis image off;
title('Image en noir et blanc');

if ~exist('results')
    mkdir('results')
end
imwrite(I,'results/image_noir_et_blanc.png'); % save the black and white image
print(1,'results/figure_1.jpg','-djpeg'); % save figure 1
% close(1); in case you want matlab to close figure 1

% add gaussian noise to the image
sigma_noise=0.1;
I_noise=I+randn(size(I))*sigma_noise;
imwrite(I_noise,'results/image_bruitee.png'); % save the black and white image

%% 2. Basic Image Processing

% Gaussian convolution
I_blurred1=gaussian_convolution(I_noise,1); 
I_blurred3=gaussian_convolution(I_noise,3); 
I_blurred10=gaussian_convolution(I_noise,10); 

figure(2); 
subplot(2,2,1);
imagesc(I_noise);
colormap(gray);
axis image off;
title('Image bruitee'); 
subplot(2,2,2);
imagesc(I_blurred1);
colormap(gray);
axis image off;
title('Image bruitee convolee, sigma s=1');
subplot(2,2,3); 
imagesc(I_blurred3);
colormap(gray);
axis image off;
title('Image bruitee convolee, sigma s=3'); 
subplot(2,2,4); 
imagesc(I_blurred10);
colormap(gray);
axis image off;
title('Image bruitee convolee, sigma s=10'); 
print(2,'results/convolution_gaussienne.jpg','-djpeg'); 


% Gradients 
[dIx dIy dI_norm dI_orientation]=compute_gradient(I_blurred3);

figure(3); 
imagesc(dI_norm);
colormap(gray);
title('Norme du gradient de l image bruitee convolee (sigma s=3)'); 
print(3,'results/norme_gradient.jpg','-djpeg'); 


% Visualize thresholded gradients
dI_norm_thresh1=dI_norm>0.01;
dI_norm_thresh2=dI_norm>0.02;
dI_norm_thresh3=dI_norm>0.05;

figure(4); 
subplot(2,2,1);
imagesc(I_blurred3);
colormap(gray);
axis image off;
title('Image buitee convolee (sigma s=3)'); 
subplot(2,2,2);
imagesc(dI_norm_thresh1);
colormap(gray);
axis image off;
title('Gradient de l image seuille a 0.01');
subplot(2,2,3); 
imagesc(dI_norm_thresh2);
colormap(gray);
axis image off;
title('Gradient de l image seuille a 0.02'); 
subplot(2,2,4); 
imagesc(dI_norm_thresh3);
colormap(gray);
axis image off;
title('Gradient de l image seuille a 0.05'); 
print(4,'results/gradient_seuil_variance3.jpg','-djpeg'); 


%Impact of Gaussian kernel variance on thresholded gradients
[dIx2 dIy2 dI_norm2 dI_orientation2]=compute_gradient(I_blurred1);

dI_norm2_thresh1=dI_norm2>0.05;
dI_norm2_thresh2=dI_norm2>0.08;
dI_norm2_thresh3=dI_norm2>0.1;

figure(5)
subplot(2,2,1);
imagesc(I_blurred1);
colormap(gray);
axis image off;
title('Image buitee convolee (sigma s=1)'); 
subplot(2,2,2);
imagesc(dI_norm2_thresh1);
colormap(gray);
axis image off;
title('Gradient de l image seuille a 0.05');
subplot(2,2,3); 
imagesc(dI_norm2_thresh2);
colormap(gray);
axis image off;
title('Gradient de l image seuille a 0.08'); 
subplot(2,2,4); 
imagesc(dI_norm2_thresh3);
colormap(gray);
axis image off;
title('Gradient de l image seuille a 0.1'); 

print(5,'results/gradient_seuil_variance1.jpg','-djpeg'); 


%% 3. Canny edge detector

% Quantify gradient orientations
quantified_orientation=quantify_gradient(dI_orientation);

% This is just to check that your results are meaningful, use it!
orientation=1;
figure(6);
imagesc(quantified_orientation==orientation);
axis image off;
colormap(gray);
title(sprintf('Gradient oriente verticalement (entre 3*pi/8 et 5*pi/8 en valeur absolue)',orientation));
print(6,'results/grad_orientation.jpg','-djpeg'); 


% Perform non-max suppression
threshold =0.02;
nms_edges=non_max_suppression(dI_norm,quantified_orientation,threshold);

% Impact of the noise in the input
I2_noise=I+randn(size(I))*0.5;
I2_blurred3=gaussian_convolution(I2_noise,3);
[dI2x dI2y dI2_norm dI2_orientation]=compute_gradient(I2_blurred3); 
dI2_norm_thresh2=dI2_norm>0.03;
quantified_orientation2=quantify_gradient(dI2_orientation);
nms_edges2=non_max_suppression(dI2_norm,quantified_orientation2,0.03);

figure(7);
subplot(2,2,1);
imagesc(dI_norm_thresh2); 
colormap(gray);
axis image off;
title('Gradient seuille a 0.02 (bruit=0.1, sigma s=3)'); 
subplot(2,2,2); 
imagesc(nms_edges);
colormap(gray);
axis image off;
title('Apres suppression des non-maximaux'); 
subplot(2,2,3);
imagesc(dI2_norm_thresh2); 
colormap(gray);
axis image off;
title('Gradient seuille a 0.03 (bruit=0.5, sigma s=3)'); 
subplot(2,2,4); 
imagesc(nms_edges2);
colormap(gray);
axis image off;
title('Apres suppression des non-maximaux'); 
print(7,'results/suppression_non_max_bruit_impact','-djpeg'); 


% Impact of the size of the blur kernel
#we take the image with noise 0.1 we blurred with a Gaussian kernel of variance 1
#its gradient information were computed line 117 in [dIx2 dIy2 dI_norm2 dI_orientation2]
#and a "good" threshold was given by dI_norm2_thresh2=dI_norm2>0.08;
quantified_orientation3=quantify_gradient(dI_orientation2);
nms_edges3=non_max_suppression(dI_norm2,quantified_orientation3,0.08);

figure(8); 
subplot(2,2,1);
imagesc(dI_norm_thresh2); 
colormap(gray);
axis image off;
title('Gradient seuille a 0.02 (bruit=0.1, sigma s=3)'); 
subplot(2,2,2); 
imagesc(nms_edges);
colormap(gray);
axis image off;
title('Apres suppression des non-maximaux'); 
subplot(2,2,3);
imagesc(dI_norm2_thresh2); 
colormap(gray);
axis image off;
title('Gradient seuille a 0.08 (bruit=0.1, sigma s=1)'); 
subplot(2,2,4); 
imagesc(nms_edges3);
colormap(gray);
axis image off;
title('Apres suppression des non-maximaux'); 
print(8,'results/suppression_non_max_taille_impact','-djpeg'); 

% Canny edges
% parameters
sigma = 2; % Deviation standard du flou gaussien
s1 = 0.05; % Seuil haut de l'hysteresis
s2 =  0.002; % Seuil bas  de l'hysteresis

edges0=canny_edges(I,sigma,s1,s2);

figure(9)
subplot(1,2,1);
imagesc(I);
colormap(gray);
axis image off;
title('Image non bruitee'); 
subplot(1,2,2); 
imagesc(edges0);
colormap(gray);
axis image off;
title('Filtre de Canny (hysteresis S=0.05, s=0.002)'); 
print(9,'results/canny_sans_bruit','-djpeg');  

% as a reminder, dI_norm is the norm of the gradient of the image with noise =0.1
% and blur kernel variance =3
dI_norm_thresh4=dI_norm>s1;
dI_norm_thresh5=dI_norm>s2;

edges=canny_edges(I_noise,sigma,s1,s2);

figure(10)
subplot(2,2,1);
imagesc(nms_edges);
colormap(gray);
axis image off;
title('Gradient seuille a 0.02 apres suppression des non-maximaux'); 
subplot(2,2,2); 
imagesc(dI_norm_thresh4);
colormap(gray);
axis image off;
title('Gradient seuille a S = 0.05'); 
subplot(2,2,3);
imagesc(dI_norm_thresh5); 
colormap(gray);
axis image off;
title('Gradient seuille a s = 0.002'); 
subplot(2,2,4); 
imagesc(edges);
colormap(gray);
axis image off;
title('Hysteresis S = 0.05 , s = 0.002'); 
print(10,'results/canny_detecteur','-djpeg');  

%% 4. Bilateral Filter

% Edge-aware smoothing
Irgb = double(imread('images/rock2.png'))./255; % read the image
I=get_luminance(Irgb); % get luminance
rgb_ratio=Irgb./repmat(I,[1 1 3]); % compute image color
smoothed_image=BF(I,5,0.1);
output=max(0,min(1,repmat(smoothed_image, [1 1 3]).*rgb_ratio));%

figure(11)
imagesc(output,[0 1]);
axis image off;
title('Image lissee avec filtre bilateral (sigma spatial=5, sigma_range=0.1)');
print(11,'results/filtre_bilateral','-djpeg'); 

%Extreme values of sigma spatial and sigma_range
smoothed_image2=BF(I,2,0.5);
output2=max(0,min(1,repmat(smoothed_image2, [1 1 3]).*rgb_ratio));

smoothed_image3=BF(I,10,0.01);
output3=max(0,min(1,repmat(smoothed_image3, [1 1 3]).*rgb_ratio));%

figure(12)
subplot(2,1,1);
imagesc(output2,[0 1]);
axis image off;
title('Image lissee avec filtre bilateral (sigma spatial=2, sigma range=0.5)');
subplot(2,1,2);
imagesc(output3,[0 1]);
axis image off;
title('Image lissee avec filtre bilateral (sigma spatial=10, sigma range=0.1)');
print(12,'results/filtre_bilateral_cas_limites','-djpeg'); 

% Detail enhancement
weight = 3
enhanced_image_BF=smoothed_image+weight*(I-smoothed_image);
gaussian_image=gaussian_convolution(I,5);
enhanced_image_gaussian=gaussian_image+weight*(I-gaussian_image);

figure(13)
subplot(2,1,1);
imagesc(enhanced_image_BF);
colormap(gray);
axis image off;
title('Renforcement des details (avec poids 3) avec filtre bilateral (sigma spatial=5, sigma range=0.1) ');
subplot(2,1,2);
imagesc(enhanced_image_gaussian);
colormap(gray);
axis image off;
title('Renforcement des details (avec poids 3) avec convolution gaussienne (sigma spatial = 5)');
print(13,'results/renforcement_details','-djpeg'); 

%% 5. Optionnal

edges_after_BF=canny_edges(smoothed_image,sigma,s1,s2);

figure(14)
subplot(1,1,1);
imagesc(edges_after_BF);
colormap(gray);
axis image off;
title('Détecteur de Canny  (hysteresis S=0.05, s=0.002) après filtre bilatéral (sigma spatial=5, sigma_range=0.1)'); 
print(14,'results/canny_sans_bruit','-djpeg');  