function [O]=gaussian_convolution(I,sigma)
% This function computes the convolution of the grayscale image I with a 
% gaussian of variance sigma    

if size(I,3)~=1
    error('The image must be grayscale');
end

G=gaussian_filter_2d(sigma); 
% note that this can be done using the image processing toolbox function
% 'fspecial' which is not available at the ENPC

O=conv2(I,G,'same');
% note that this can be done using the image processing toolbox function
% 'imfilter' which is not available at the ENPC

end