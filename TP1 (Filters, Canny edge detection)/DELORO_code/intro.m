% This is a matlab scritp.
% You can run the full script by clicking on the red arrow or pressing F5.
% You can also copy-paste the lines you want to run in the command line
% or select them and press F9
% '%' make the rest of the line a comment
% '%% ' at the beginning of a ligne starts a section that you can run by
% pressing Ctrl+
% You can get the documentation on a matlab function by 
% >> doc function_name
% or
% >> help function_name


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Basic operations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Some types
a=true; % boolean
if a
    fprintf('a is true\n'); % print text 
else
    fprintf('a is false\n'); % print text
end
b=1+2*3/4; % basic operations
c=b+1;% without ';' Matlab print the result
s='string'

%% Arrays
u=[1 2 3]; % row vector
v=[1;2;3]; % column vector
vt=v'; % transpose
p=u*v; % matrix product
P=v*u;
q=u.*u; % point to point product 
M=[1 2 3; 4 5 6]; % matrix
t=size(M); % gives the size of m
Mu=cat(1,M,u) % concatenate m and u along the first dimension
Z=zeros([2 3 4]); % array of size 2x3x4
O=ones([2 3]); % array of size 2x3
Id=eye(5); % identity matrix of size 5x5
R=rand(3); % random matrix of size 3x3 with uniform values in [0 1]
Rn=randn(3); % random matrix of size 3x3 with standard normal distribution
sum_o1=sum(O,1); % sum along the first dimension
sum_o=sum(O(:)); % sum all values

Rs=R(1:2,end-1:end); % submatrix
% Indices begin at 1, not 0
Rt=Rn.*(Rn>0); % positive values of R

%% plots
x=-5:0.1:5; % vector of values between -5 and 5 spaced by 0.1
y1=exp(-x.^2);
y2=-x.*y1; 
figure(1) % open figure
plot(x,y1)
title('Gaussian')
figure(2) 
plot(x,y2)
title('Gaussian derivative')
% In case you have too many figures open
% >> close all
% In case you want matlab to close figure 1:
% >> close(1);

%% save 
mkdir('results'); % create a folder
print(1,'results/plot_1.jpg','-djpeg'); % save a jpeg version of figure 1
save('results/a_few_variables.mat','x','y1','y2'); % save x, y1 and y2
clear all; % clear all variables from the workspace
load('results/a_few_variables.mat'); % load a mat file
save('results/workspace.mat'); % save all the workspace. Warning, this will easily be big!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% More advanced but usefull things (can be explored later)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Breakpoints: 
% You can create a breakpoint by clicking on the left of the code or
% pressing F12. The execution will stop at the breakpoint. This can be
% usefull for debugging.

%% Debugging
% You can use the command 'dbstop error' to have matlab set a breakpoint in
% case of error. To clear all breakpoint 'dbclear all'

%% Optimizing your code: 
% Array operations are usually much faster than for loops in Matlab.
% Sometime, you may not understand why your code is slow.
% You can use a timer 'tic' starts it and 'toc' print the time.
% You can also use Matlab profiler.
% Try to run in the command line:
% >> profile on 
% >> profile off
% >> profile report
% to see in details where the time is spent when running this tutorial

N=1000;
a=rand(N);
b=rand(N);

tic
c=zeros(N);
for i=1:N
    for j=1:N
        c(i,j)=a(i,j)+b(i,j);
    end
end
toc
fprintf('Computing the sum with for loops took %02f seconds\n',toc);
tic
d=a+b;
fprintf('Computing the sum with matrix sum took %02f seconds\n\n',toc);
