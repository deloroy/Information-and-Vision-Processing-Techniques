function disparity = comp_MAP_labeling(beliefs)
% beliefs: a 3D array of size height x width x num_disp_value; each
%   element beliefs(y,x,l) is the belief of pixel p = (y,x) taking the
%   label l
% disparity: a 2D array of size height x width the disparity value of each 
%   pixel; the disparity values range from 1 till num_disp_value 
    [O,disparity] = min(beliefs,[],3);

end
    