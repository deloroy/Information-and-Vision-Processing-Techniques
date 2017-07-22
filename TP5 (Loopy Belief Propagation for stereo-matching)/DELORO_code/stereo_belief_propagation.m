function [disparity, energy] = stereo_belief_propagation(img_left, img_right, lambda)
num_disp_values = 16; % number of disparity values
tau             = 15; 
num_iterations  = 60; % number of iterations
[height, width] = size(img_left);

% compute the data cost term
% data_cost: a 3D array of size height x width x num_disp_value; each
%   element data_cost(y,x,l) is the cost of assigning the label l to pixel 
%   p = (y,x)
data_cost = comp_data_cost(img_left, img_right, num_disp_values, tau); 

% allocate memory for storing the energy at each iteration
energy = zeros(num_iterations, 1);

% Initialize the messages at iteration 0 to all zeros

% msg_up : a 3D array of size height x width x num_disp_value; each vector
%   msg_up(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel up with coordinates q = (y-1,x)
msg_up    = zeros([height, width, num_disp_values], 'single'); 
% msg_down : a 3D array of size height x width x num_disp_value; each vector
%   msg_down(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel down with coordinates q = (y+1,x)
msg_down  = zeros([height, width, num_disp_values], 'single');
% msg_left : a 3D array of size height x width x num_disp_value; each vector
%   msg_left(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel left with coordinates q = (y,x-1)
msg_left  = zeros([height, width, num_disp_values], 'single');
% msg_right : a 3D array of size height x width x num_disp_value; each vector
%   msg_right(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel right with coordinates q = (y,x+1)
msg_right = zeros([height, width, num_disp_values], 'single');

for iter = 1:num_iterations
    % update messages
    [ msg_up, msg_down, msg_left, msg_right] = update_messages( msg_up, msg_down, msg_left, msg_right, data_cost, lambda);

    [ msg_up, msg_down, msg_left, msg_right] = normalize_messages(msg_up, msg_down, msg_left, msg_right);
    
    % compute  beliefs
    % beliefs: a 3D array of size height x width x num_disp_value; each
    %   element beliefs(y,x,l) is the belief of pixel p = (y,x) taking the
    %   label l
    beliefs = comp_belief( data_cost, msg_up, msg_down, msg_left, msg_right );
    
    % compute MAP disparities
    % disparity: a 2D array of size height x width the disparity value of each 
    %   pixel; the disparity values range from 1 till num_disp_value 
    disparity = comp_MAP_labeling(beliefs);
    
    % compute MRF energy    
    energy(iter) = comp_energy(data_cost, disparity, lambda);
    
    fprintf('Iteration #%d:: Energy %f\n', iter, energy(iter));
    
    %figure(100); clf(100); 
    %imagesc(disparity); colormap(gray); 
    %title(sprintf('Disparity at iteration %d', iter))
end
end
