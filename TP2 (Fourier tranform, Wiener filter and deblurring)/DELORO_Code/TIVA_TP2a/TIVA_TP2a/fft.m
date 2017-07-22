#1. TRANSFORMEE DE FOURIER D'UNE IMAGE

#Loading the image
Irgb=imread('treewall.jpg');
Irgb=double(Irgb)./255;
Ib=get_luminance(Irgb); % convert the color image into grayscale
[h,w,c]=size(Ib);

#Showing RGB & BW images
figure(1);
subplot(1,2,1);
image(Irgb);
axis off;
axis image;
title('Image RGB');
subplot(1,2,2); 
imagesc(Ib);
colormap(gray);
axis image off;
title('Image en noir et blanc');

if ~exist('results')
    mkdir('results')
end
print(1,'results/images.jpg','-djpeg');

#Computing the FFT
fourier=fft2(Ib); #2-dimensional fft
fourier_shifted=fftshift(fourier); 
#visualizing with low-frequences at the middle of the image
fourier_real=real(fourier_shifted); 
fourier_imag=imag(fourier_shifted);
fourier_mod=abs(fourier_shifted);
fourier_phase=imag(log(fourier_shifted));

figure(2);
subplot(2,2,1);
imagesc(log(abs(fourier_real)));
colormap(gray);
axis image off;
title('Partie reelle');
subplot(2,2,2);
imagesc(log(abs(fourier_imag)));
colormap(gray);
axis image off;
title('Partie imaginaire');
figure(2);
subplot(2,2,3);
imagesc(log(fourier_mod));
axis off;
axis image;
title('Logarithme du module');
subplot(2,2,4); 
imagesc(fourier_phase);
colormap(gray);
axis image off;
title('Phase');
print(2,'results/fft.jpg','-djpeg');

#Results of the low-pass filter applied the wall-tree image

#building a low-pass filter for h*w dimensions and fc cut-off frequency, 
#adapted for images whose low-frequences have been previously shifted at the middle
fc=0.75;
filter=low_pass_filter(h,w,fc);
#applying a low_pass_filter on the fourier transform shifted
fourier_filtered_shifted=filter.*fourier_shifted; 

figure(3);
subplot(2,2,1);
imagesc(log(fourier_mod));
colormap(gray);
axis image off;
title('Log du module de la fft');
subplot(2,2,2); 
imagesc(filter);
colormap(gray);
axis image off;
title('Filtre passe-bas');
subplot(2,2,3); 
image(log(abs(fourier_filtered_shifted)));
colormap(gray);
axis image off;
title('Log du module de la fft filtree a 0.75 et shiftee');
subplot(2,2,4);
imagesc(real(ifft2(ifftshift(fourier_filtered_shifted))));
axis off;
axis image;
title('Ifft de la fft filtree a 0.75 ');
print(3,'results/passe_bas.jpg','-djpeg');

figure(4);
subplot(2,2,1);
imagesc(real(ifft2(ifftshift(low_pass_filter(h,w,0.1).*fourier_shifted))));
colormap(gray);
axis off;
axis image;
title('Ifft de la fft filtree a 0.1 ');
subplot(2,2,2);
imagesc(real(ifft2(ifftshift(low_pass_filter(h,w,0.3).*fourier_shifted))));
axis off;
axis image;
title('Ifft de la fft filtree a 0.3 ');
subplot(2,2,3);
imagesc(real(ifft2(ifftshift(low_pass_filter(h,w,0.6).*fourier_shifted))));
axis off;
axis image;
title('Ifft de la fft filtree a 0.6 ');
subplot(2,2,4);
imagesc(real(ifft2(ifftshift(low_pass_filter(h,w,0.9).*fourier_shifted))));
axis off;
axis image;
title('Ifft de la fft filtree a 0.9 ');
print(4,'results/passe_bas_try.jpg','-djpeg');

#Results of the low-pass filter applied to a black rectangle on white background

#building the black rectangle on white background
abs=1:w;
abs=ceil(w*0.30)<abs & abs<ceil(w*0.70);
ord=1:h;
ord=ceil(h*0.35)<ord & ord<ceil(h*0.65);
Rect=!(ord'*abs); 

#fft computing
Rect_fourier=fft2(Rect);
Rect_fourier_shifted=fftshift(Rect_fourier);
Rect_fourier_mod=abs(Rect_fourier_shifted);

#applying the low-pass filter
fc=0.75;
Rect_fourier_filtered_shifted=filter.*Rect_fourier_shifted; 

figure(6);
subplot(2,2,1);
imagesc(Rect);
axis image;
colormap(gray);
title('Image du rectangle noir sur fond blanc');
subplot(2,2,2); 
imagesc(filter);
axis image;
colormap(gray);
title('Filtre passe-bas');
subplot(2,2,3); 
imagesc(log(abs(Rect_fourier_filtered_shifted)));
axis image;
colormap(gray);
title('Log du module de la fft filtree a 0.75 et shiftee');
subplot(2,2,4);
imagesc(real(ifft2(ifftshift(Rect_fourier_filtered_shifted))));
axis image;
title('Ifft de la fft filtree a 0.75 ');
print(6,'results/passe_bas_rect.jpg','-djpeg');

#2. ALIASING

#Loading the image
Irgb2=imread('brickwall.jpg');
#Irgb2=double(Irgb2)./255;
[h,w,c]=size(Irgb2);

#Showing RGB & BW images
figure(7);
image(Irgb2);
axis off;
axis image;
title('Image RGB');
print(7,'results/brickwall.jpg','-djpeg');

#Subsampling of I
figure(8);
for T=2:10
     I_subsampled=subsampling(Irgb2,T);
     subplot(3,3,T-1);
     image(I_subsampled);
     #colormap(gray);
     axis off;
     axis image;
     title(['1 pixel sur ',num2str(T)]);
end
print(8,'results/brickwall_subsampled.jpg','-djpeg');

figure(9);
     subplot(1,2,1);
     image(subsampling(Irgb2,2));
     #colormap(gray);
     axis off;
     axis image;
     title('1 pixel sur 2');
     subplot(1,2,2);
     image(subsampling(Irgb2,10));
     #colormap(gray);
     axis off;
     axis image;
     title('1 pixel sur 10');
print(9,'results/brickwall_subsampled_extr.jpg','-djpeg');

