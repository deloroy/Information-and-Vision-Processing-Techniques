function data_cost = comp_data_cost(img_left, img_right, num_disp_vals, tau)
% data_cost: a 3D array of size height x width x num_disp_value; each
%   element data_cost(y,x,l) is the cost of assigning the label l to pixel 
%   p = (y,x)
% tau : scalar value
% num_disp_vals : number of dispary values. The disparity values range
%   between 1 and num_disp_vals
    [H,W] = size(img_left);
    data_cost = zeros(H,W,num_disp_vals);
    for k=1:num_disp_vals,
        data_cost(:,k:W,k)=min(abs((img_left(:,k:W)-img_right(:,1:(W-k+1)))/1.),tau);
    end
    
end