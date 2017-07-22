function I_deblurred=deblurr(I,K,L)
#Builds the Wiener filter with K,L parameters
#And applies it to the fourier transform of the image
#Returns the image inverse of the fourier transform

#Building the convolution kernel (L-length horizontal)
[N1,N2]=size(I);
seg=zeros(size(I));
seg(1,1+mod((1:L)-ceil(L/2),N2))=1/L;
#Computing the tfd of the kernel
seg_fourier=fft2(seg);
seg_fourier_conj=conj(seg_fourier);

#Building the Wiener filter
K_mat=K*ones(size(I));
filter_Wiener=zeros(size(I));
filter_Wiener=seg_fourier_conj./(seg_fourier.*seg_fourier_conj+K_mat);

#Computing the tfd of the image
I_fourier=fft2(I);

#Applying the Wiener filter to the image's tfd
I_fourier_filtered=filter_Wiener.*I_fourier;

#Taking and returning the inverse 
I_deblurred=ifft2(I_fourier_filtered);

end