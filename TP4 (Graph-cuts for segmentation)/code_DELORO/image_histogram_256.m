function histogram = image_histogram_256(image)
assert(strcmp(class(image),'uint8'))
histogram = accumarray(image(:),1,[256 1]);
end