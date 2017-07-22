function [ msg_up, msg_down, msg_left, msg_right] = update_messages( msg_up_prev, msg_down_prev, msg_left_prev, msg_right_prev, data_cost, lambda)
% data_cost: a 3D array of size height x width x num_disp_value; each
%   element data_cost(y,x,l) is the cost of assigning the label l to pixel 
%   p = (y,x)
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
% lambda : scalar value 

% For convenience don't compute the messages that are send from pixels that are on the boundaries of the image. 
% Compute the messages only for the pixels with coordinates (y,x) = ( 2:(height-1) , 2:(width-1) )

   [H,W,num_disp_vals]=size(msg_up_prev);
   
   msg_up=zeros(H,W,num_disp_vals);
   tmp_up=zeros(H,W,num_disp_vals);
   tmp_up(2:H-1,2:W-1,:) = data_cost(2:H-1,2:W-1,:) + msg_up_prev(1:H-2,2:W-1,:) + msg_left_prev(2:H-1,3:W,:) + msg_right_prev(2:H-1,1:W-2,:);  
   msg_up =  min(min(tmp_up,[],3)+lambda,tmp_up);
   
   msg_down=zeros(H,W,num_disp_vals);
   tmp_down=zeros(H,W,num_disp_vals);
   tmp_down(2:H-1,2:W-1,:) = data_cost(2:H-1,2:W-1,:) + msg_down_prev(3:H,2:W-1,:) + msg_left_prev(2:H-1,3:W,:) + msg_right_prev(2:H-1,1:W-2,:);   
   msg_down =  min(min(tmp_down,[],3)+lambda,tmp_down);
   
   msg_right=zeros(H,W,num_disp_vals);
   tmp_right=zeros(H,W,num_disp_vals);
   tmp_right(2:H-1,2:W-1,:) = data_cost(2:H-1,2:W-1,:)  + msg_right_prev(2:H-1,1:W-2,:) + msg_down_prev(1:H-2,2:W-1,:) + msg_up_prev(3:H,2:W-1,:);  
   msg_right =  min(min(tmp_right,[],3)+lambda,tmp_right);
   
   msg_left=zeros(H,W,num_disp_vals);
   tmp_left=zeros(H,W,num_disp_vals);
   tmp_left(2:H-1,2:W-1,:) = data_cost(2:H-1,2:W-1,:) + msg_left_prev(2:H-1,3:W,:) + msg_down_prev(1:H-2,2:W-1,:) + msg_up_prev(3:H,2:W-1,:);  
   msg_left =  min(min(tmp_left,[],3)+lambda,tmp_left);
   
end

