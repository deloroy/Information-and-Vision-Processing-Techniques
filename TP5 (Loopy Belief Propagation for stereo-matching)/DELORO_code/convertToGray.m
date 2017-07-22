function gray = convertToGray(rgb)
T = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
[height, width, channels] = size(rgb);
assert(channels == 3);
rgb = reshape(rgb(:),height*width,channels);

if isa(rgb, 'uint8')  
    gray = uint8(reshape(double(rgb)*T(1,:)', [height, width]));
else
    gray = reshape(rgb*T(1,:)', [height, width]);
end

end