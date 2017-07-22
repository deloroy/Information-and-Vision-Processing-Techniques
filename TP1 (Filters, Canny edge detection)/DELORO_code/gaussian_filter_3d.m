function f=gaussian_filter_3d(sigma)
if length(sigma)~=3
    error('sigma must have three dimensions\n');
end

int_sigma=ceil(sigma);

x=(-2*int_sigma(2)):(2*int_sigma(2));
fx=exp(-x.^2/(2*sigma(2)^2));

y=(-2*int_sigma(1)):(2*int_sigma(1));
fy=exp(-y.^2/(2*sigma(1)^2));

f_2d=fy'*fx;

z=(-2*int_sigma(3)):(2*int_sigma(3));
fz=exp(-(z.^2)/(2*(sigma(3)^2)));
fz=reshape(fz,[1 1 length(fz)]);

f=repmat(fz,[size(f_2d,1) size(f_2d,2) 1]).*repmat(f_2d,[1,1,length(fz)]);

%f=f./sum(f(:));

end