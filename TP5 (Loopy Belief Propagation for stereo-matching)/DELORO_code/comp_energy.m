function energy = comp_energy(data_cost, disparity, lambda)
% data_cost: a 3D array of size height x width x num_disp_value; each
%   element data_cost(y,x,l) is the cost of assigning the label l to pixel 
%   p = (y,x)
% disparity: a 2D array of size height x width the disparity value of each 
%   pixel; the disparity values range from 1 till num_disp_value 
% lambda : a scalar value
% energy : a scalar value

   [H,W]=size(disparity);   
   regul_term=sum((disparity(1:H-1,:)!=disparity(2:H,:))(:));
   regul_term+=sum((disparity(:,1:W-1)!=disparity(:,2:W))(:));
   
   %data_term = sum(data_cost(1:H,1:W,disparity(1:H,1:W))(:)); 
   %too long ("out of memory"), thus we use a loop
   
   data_term=0;
   for j=1:H,
      for i=1:W,
          data_term += data_cost(j,i,disparity(j,i));
      end
   end
      
   energy = data_term + lambda * regul_term;
end