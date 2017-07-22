function I_subsampled=subsampling(I,T)

[h,w,c]=size(I);
I_subsampled=I(1:T:h,1:T:w,1:c);

end