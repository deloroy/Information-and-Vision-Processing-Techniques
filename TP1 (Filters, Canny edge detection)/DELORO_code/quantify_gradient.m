function quant_orientation=quantify_gradient(orientation)
% This function must quantify the gradient in 4 orientations.
% It returns a matrix orientation which values are in {1,2,3,4}

quant_orientation=zeros(size(orientation));

orientations_1=(orientation>3*pi/8) | (orientation<=-3*pi/8);
quant_orientation(orientations_1)=1;

% if M is a matrix and B a boolean  
% matrix of same size, M(B)=a gives the value a to the matrix M at the
% places where B is true

%% To complete: use the same model for the other orientation bins

orientations_2=(orientation>pi/8) & (orientation<=3*pi/8);
quant_orientation(orientations_2)=2;
orientations_3=(orientation>-pi/8) & (orientation<=pi/8);
quant_orientation(orientations_3)=3;
orientations_4=(orientation>-3*pi/8) & (orientation<=-pi/8);
quant_orientation(orientations_4)=4;

end