function labels = mrf_mincut(unary, edge_weights, pairwise)
%  Parameters:
%   unary:: A CxN matrix specifying the potentials (data term) for
%     each of the C possible classes at each of the N nodes.
%   edge_weights:: An NxN sparse matrix specifying the graph structure and
%     cost for each link between nodes in the graph. Check 'help sparse' in \
%     matlab
%   pairwise:: A CxC matrix specifying the pairwise potential
%
% Outputs:
%   labels:: A 1xN vector of the final labels.
% 
% Note:
%   Normally the code should work, but incase you encounter any problem in 
%   executing the code, run compile.m and try executing your code. If the 
%   problem still persists please let us know.
%
%
% Energy(X) = \sum_i unary(X_i, i) + \sum_{i,j} edge_weights(i,j) * pairwise(X_i,X_j), where X = {X_i}, for i=1...N

segclass = zeros(1,size(unary,2));
assert(size(unary,2)==size(edge_weights,1),'Dimension mis-match!!');
assert(size(unary,1)==size(pairwise,1),'Dimension mis-match!!');
labels =  GCMex(segclass, single(unary), edge_weights, single(pairwise),1);
