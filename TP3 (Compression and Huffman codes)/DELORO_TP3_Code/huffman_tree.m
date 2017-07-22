function []=huffman_tree(p,symbols)
if size(p,2)~=1,
    error('p must be a column vector');
end
n=length(p);
node_list=(1:n)';
children_table=zeros(2*n-1,2);
p_all=[p;zeros(n-1,1)];
%print_format=[repmat('%6.4f ',1,n) '\n'];
for k=1:n-1,
    [p, I]=sort(p,'ascend');
    node_list=node_list(I);
    %fprintf(print_format,p);
    current_node=n+k;
    children_table(current_node,:)=node_list(1:2)';
    node_list(2)=current_node;
    p(2)=p(1)+p(2);
    p_all(current_node)=p(2);
    node_list(1)=0;
    p(1)=Inf;
    %fprintf(print_format,p);
end
depth=zeros(2*n-1,1); % Longueur du pr�fixe associ� au noeud
cpl=zeros(2*n-1,1); % Bord inf�rieur des rectangles
cpu=ones(2*n-1,1);  % Bord sup�rieur des rectangles
% cpu est la fonction de r�partition pour les pr�fixes en binaire
figure(2)
clf
for k=(2*n-1):-1:(n+1),
    for i=1:2,
        child=children_table(k,i);
        depth(child)=depth(k)+1;
        if i==1,
            cpl(child)=cpl(k);
            cpu(child)=cpl(k)+p_all(child);
            figure(2)
            text(depth(child)-0.5,cpl(child)+p_all(child)/2,'0');
        else
            cpl(child)=cpu(k)-p_all(child);
            cpu(child)=cpu(k);
            figure(2)
            text(depth(child)-0.5,cpl(child)+p_all(child)/2,'1');
        end
        figure(2)
        rectangle('Position',[depth(child)-1 cpl(child) 1 p_all(child)]);
    end
end
% Ecrire le symbole encod� � chaque feuille
for k=1:n,
text(depth(k)+0.5,cpl(k)+p_all(k)/2,symbols{k});
end
title('Arbre du code de Huffman');
axis([0 max(depth)+2 0 1]);

end
