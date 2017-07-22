function [ msg_up, msg_down, msg_left, msg_right] = normalize_messages(msg_up, msg_down, msg_left, msg_right)
% msg_up : a 3D array of size height x width x num_disp_value; each vector
%   msg_up(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel up with coordinates q = (y-1,x)
% msg_down : a 3D array of size height x width x num_disp_value; each vector
%   msg_down(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel down with coordinates q = (y+1,x)
% msg_left : a 3D array of size height x width x num_disp_value; each vector
%   msg_left(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel left with coordinates q = (y,x-1)
% msg_right : a 3D array of size height x width x num_disp_value; each vector
%   msg_right(y,x,1:num_disp_values) is the message vector that the pixel 
%   p = (y,x) will send to the pixel right with coordinates q = (y,x+1)

mean_msg_val = mean(msg_up, 3);
for d = 1:size(msg_up,3)
    msg_up(:,:,d) = msg_up(:,:,d) - mean_msg_val;
end

mean_msg_val = mean(msg_down, 3);
for d = 1:size(msg_down,3)
    msg_down(:,:,d) = msg_down(:,:,d) - mean_msg_val;
end

mean_msg_val = mean(msg_left, 3);
for d = 1:size(msg_left,3)
    msg_left(:,:,d) = msg_left(:,:,d) - mean_msg_val;
end

mean_msg_val = mean(msg_right, 3);
for d = 1:size(msg_right,3)
    msg_right(:,:,d) = msg_right(:,:,d) - mean_msg_val;
end

end