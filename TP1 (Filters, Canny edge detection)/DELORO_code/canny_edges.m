function edges=canny_edges(I,sigma,t1,t2)
% t1>t2

I_blurred=gaussian_convolution(I,sigma); 
[dIx dIy dI_norm dI_orientation]=compute_gradient(I_blurred);
quantified_orientation=quantify_gradient(dI_orientation);
nms_edges_1=non_max_suppression(dI_norm,quantified_orientation,t1);
nms_edges_2=non_max_suppression(dI_norm,quantified_orientation,t2);
edges=nms_edges_1; %local maxima reaching the threshold t1 are edges
[H,W]=size(edges);

%% Hysteresis : finding the edges between t2 and t1
[edges_to_visit_i edges_to_visit_j]=find(nms_edges_1); % find the indices
% of the most confident edges

while ~isempty(edges_to_visit_i)
    for k=1:length(edges_to_visit_i)
        edge_i=edges_to_visit_i(k);
        edge_j=edges_to_visit_j(k);
        %% Part to complete: 
        % Where can there a new edge? With which condition is it indeed a new edge?
        % Understand why the code will work if you just put the
        % value of 'edges(i,j)' to 1 for those new edges
        % Warning; be sure your indices don't go out of the arrays
        for di=-1:1
             for dj=-1:1
                 %we keep the neighbours of the edge that pass the threshold t2
                 %"a local maximum reaching the threshold t2 is an edge 
                 %if one of his neighbour is an edge" 
                 if di!=0 || dj!=0
                    nbr_i=edge_i+di;
                    nbr_j=edge_j+dj;
                    if nbr_i>1 && nbr_j>1 && nbr_i<H && nbr_j<W
                       if nms_edges_2(nbr_i,nbr_j)==1 && nms_edges_1(nbr_i,nbr_j)==0
                          edges(nbr_i,nbr_j)=1;
                       end
                    end
                 end
             end
        end
    end
    % finding the edges that have not yet been extended
    [edges_to_visit_i edges_to_visit_j]=find(edges & ~nms_edges_1);
    % and labelling the edges that have just been extended
    nms_edges_1=edges;
end

end