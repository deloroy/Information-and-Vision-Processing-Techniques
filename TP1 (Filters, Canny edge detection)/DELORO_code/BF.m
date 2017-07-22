function smoothed_image= BF( I, sigma_spatial, sigma_range, spatial_sampling, range_sampling )


if ( ~isa( I, 'double' ) ) || ( ndims( I ) > 2 ) || max(I(:))>1
    error('the input must be a double grayscale image with values between 0 and 1\n')
end


if ~exist( 'spatial_sampling', 'var' ),
    spatial_sampling = sigma_spatial/2;
end

if ~exist( 'range_sampling', 'var' ),
    range_sampling = sigma_range/2;
end

spatial_sampling=floor(spatial_sampling);
[image_height image_width]=  size(I);


% allocate 3D grid
grid_height = ceil( ( image_height - 1 ) / spatial_sampling ) + 1;
grid_width = ceil( ( image_width - 1 ) / spatial_sampling ) + 1;
grid_depth = ceil( 1 / range_sampling ) + 1;

image_grid = zeros( grid_height, grid_width, grid_depth );
weights_grid = 0.001.*ones( grid_height, grid_width, grid_depth ); % avoid dividing by 0



[ x_coordinates , y_coordinates ] = meshgrid( 1 : image_width , 1 : image_height  ); % meshgrid allows to compute the coordinates of a grid

y_grid_coordinates = ( y_coordinates-1) / spatial_sampling  +1 ;
x_grid_coordinates = ( x_coordinates-1) / spatial_sampling  + 1;
z_grid_coordinates = I / range_sampling  + 1;


for k=1:length(I(:))
    x=round(x_grid_coordinates(k));
    y=round(y_grid_coordinates(k));
    z=round(z_grid_coordinates(k));
    image_grid(y,x,z) =image_grid(y,x,z)+I( y_coordinates(k), x_coordinates(k)) ;
    weights_grid(y,x,z)=weights_grid(y,x,z)+ 1;
end

% create a 3d gaussian kernel
kernel=gaussian_filter_3d([sigma_spatial/spatial_sampling sigma_spatial/spatial_sampling sigma_range/range_sampling]);

% convolutions
blurred_image_grid = convn( image_grid, kernel, 'same' );
blurred_weights_grid = convn( weights_grid, kernel, 'same' );

% divide
bilateral_grid = blurred_image_grid./blurred_weights_grid ;

% extract result
smoothed_image=interpn(bilateral_grid, y_grid_coordinates,x_grid_coordinates,z_grid_coordinates);
