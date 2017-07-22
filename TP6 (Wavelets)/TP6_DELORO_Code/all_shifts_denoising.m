function mean_denoised_I=all_shifts_denoising(I,th,m)
% I is the noisy input image
% th is the thresholding level that will be needed in the wavelet denoising
% or dct denoising functions
% m-1 is the number of shifts considered in each direction
%       (m=1 only uses the original image)

[sz1,sz2]=size(I);

nb_pix=floor(min(sz1,sz2)/m); %base size of shifts

sum_of_all_denoised_images=zeros(sz1,sz2);
for sx=0:nb_pix:(sz1-1) %horizontal shift
    for sy=0:nb_pix:(sz2-1) %vertical shift
        I1=shift_image(I,sx,sy);
        %TODO: DEFINE THE wavelet_denoise AND dctdenoise functions 
        denoised_I1=wavelet_denoise(I1,th);
        %denoised_I1=dctdenoise(I1,th);
        denoised_I=reverse_shift_image(denoised_I1,sx,sy);
        %figure(7);
        %imagesc(denoised_I);
        %colormap('gray')
        %axis square
        %axis off
        %keyboard;
        sum_of_all_denoised_images=sum_of_all_denoised_images+denoised_I;
    end
end

total_number_of_shifts=length(0:nb_pix:(sz1-1))*length(0:nb_pix:(sz2-1));
mean_denoised_I=sum_of_all_denoised_images/total_number_of_shifts;

%subplot(1,2,1)
%imagesc(I);
%title('Original image')
%colormap('gray')
%axis square
%axis off

%subplot(1,2,2)
%imagesc(mean_denoised_I);
%title('Denoised image using all shifts')
%colormap('gray')
%axis square
%axis off

end

function im1=shift_image(im,sx,sy)
[sz1,sz2]=size(im);
sh_idx=mod(sx-1+(1:sz1),sz1)+1;
sh_idy=mod(sy-1+(1:sz2),sz2)+1;
im1=im(sh_idx,sh_idy);
end

function im1=reverse_shift_image(im,sx,sy)
im1=shift_image(im,-sx,-sy);
end