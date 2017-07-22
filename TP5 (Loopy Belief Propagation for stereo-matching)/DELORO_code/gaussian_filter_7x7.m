function filter = gaussian_filter_7x7
x     = -3:3;
sigma = 0.6;
sigma_sq = sigma.^2;
filter_1d = exp(-(x.^2)/(2*sigma_sq));
filter = filter_1d' * filter_1d;
filter = filter / sum(filter(:));
end