#1. Plaque floue

#Loading the image
I0=imread('car.tif');
I0=double(I0)./255;
load("plaque");
I=plaque;
I=double(I)./255;
[h,w,c]=size(I);

figure(1);
subplot(1,2,1);
imagesc(I0)
title('Image de la voiture');
subplot(1,2,2) 
imagesc(I);
axis image;
colormap(gray);
title('Plaque extraite de l image apres rotation');

if ~exist('results')
    mkdir('results')
end
print(1,'results/images.jpg','-djpeg');


#2. Construction du noyau de convolution

#Building the convolution kernel :
#L-length horizontal segment which enable to average on L pixels

L=30; %estimated by zooming on the image
[N1,N2]=size(I);
seg=zeros(size(I));
seg(1,1+mod((1:L)-ceil(L/2),N2))=1/L;

#Computing the tfd of the kernel
seg_fourier=fft2(seg);
#to visualize, first we shift the tfd and then take its module
seg_fourier_shifted_mod=abs(fftshift(seg_fourier)); #for visualization

figure(2);
imagesc(log(seg_fourier_shifted_mod));
colormap(gray);
title('Logarithme du module de la TFD du noyau de convolution h');
print(2,'results/TFD_segment.jpg','-djpeg');

figure(3);
plot(seg_fourier_shifted_mod(floor(h/2),:));
title('Profil longitudinal du module de la TFD du noyau');
print(3,'results/profil_TFD_segment.jpg','-djpeg');
%We find a sinus cardinal

#Computing the tfd of the image
I_fourier=fft2(I);
I_fourier_shifted_mod=abs(fftshift(I_fourier));

figure(4);
imagesc(log(I_fourier_shifted_mod));
colormap(gray);
title('Logarithme du module de la TFD de l image de la plaque');
print(4,'results/TDF_plaque.jpg','-djpeg');



%3. Application du filtre de Wiener

#Deblurring the image with a Wiener filter with K,L parameters
K=0.01; 
I_deblurred=deblurr(I,K,L);
#Taking its real part (imag part could be non-zero because of rounding errors)
I_deblurred=real(I_deblurred);

figure(5);
subplot(1,2,1);
imagesc(I);
colormap(gray);
title('Image originale');
subplot(1,2,2);
imagesc(I_deblurred);
colormap(gray);
title('Image defloutee avec filtre de Wiener (L=30, K=0.01)');
print(5,'results/plaque_defloutee.jpg','-djpeg');

#Imwite seems to strenghten the contrast of the image, 
#which improves the reading of the numberplate
imwrite(I_deblurred,'results/defloute.png'); 
imwrite(I,'results/origine.png'); 


#Experiences on the Wiener filter

K_mat=0.01*ones(size(I));
filter_Wiener=zeros(size(I));
seg_fourier_conj=conj(seg_fourier);
filter_Wiener=seg_fourier_conj./(seg_fourier.*seg_fourier_conj+K_mat);

figure(6);
plot(abs(filter_Wiener(ceil(h/2.),:)));
title('Profil longitudinal du module du filtre de Wiener (K=0.01)');
print(6,'results/profil_Wiener.jpg','-djpeg');

inv_filter_Wiener=ifft2(filter_Wiener);

figure(7);
imagesc(abs(ifftshift(inv_filter_Wiener)));
colormap(gray);
title('Module de la TFD inverse du filtre de Wiener (K=0.01)');
print(7,'results/Wiener_inv.jpg','-djpeg');

figure(8);
plot(abs(inv_filter_Wiener(1,:)));
title('Profil longitudinal du module de l inverse du filtre de Wiener (K=0.01)');
print(8,'results/profil_Wiener_inv.jpg','-djpeg');