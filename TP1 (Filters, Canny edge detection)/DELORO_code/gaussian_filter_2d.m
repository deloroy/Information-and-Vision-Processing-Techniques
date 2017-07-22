function f=gaussian_filter_2d(sigma)
% the output matrix f should be an approximation of a 2D Gaussian filter of
% variance sigma^2 . The size of f can be adapted to sigma, for example
% f can be square of size 1+2*ceil(3*sigma)
% Tip: use the ideas of the 1D Gaussian in intro.m
% Warning : make sure sum(f(:))==1.
% Test your code by visualizing f for different sigma (e.g. 1,2 and 10)
    x=-ceil(3*sigma):ceil(3*sigma); %size of the filter
    y=exp(-x.^2/(2*sigma^2)); 
    filtre=y'*y; %filtre 2d
    filtre=filtre/sum(filtre(:)); %normalisation
    f=filtre; % array of size 2x3

end

