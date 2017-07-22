function code=huffman(p,symbols)
if size(p,2)~=1,
    error('p must be a column vector');
end
n=length(p);
%On va construire un arbre dont les n feuilles sont les symboles de
%l'alphabet et dont les n-1 noeud int�rieurs correspondent � des pr�fixes
% Les feuilles sont num�rot�es de 1 � n et les noeuds int�rieurs de n+1
% jusqu'� 2*n-1 qui est la racine

curr_list=(1:n)'; % Les noeuds de 1 � n sont les feuilles 
children_table=zeros(2*n-1,2); % A la ligne k on a les indices des 2 fils de k
print_format=[repmat('%6.3f ',1,n) '\n\n']; %Format pour la commande fprintf

%%% Etape 1: on fusionne r�cursivement les 2 noeuds de probabilit� la plus
%%% faible
for k=1:n-1,
    [p, I]=sort(p,'ascend'); % On trie les probas par ordre croissant
    curr_list=curr_list(I);  % On r�ordonne les feuilles dans le m�me ordre
    fprintf('Tri des probas par ordre croissant:\n');
    fprintf(print_format,p);
    current_node=n+k;
    children_table(current_node,:)=curr_list(1:2)';
    curr_list(2)=current_node;
    p(2)=p(1)+p(2);
    curr_list(1)=0;
    p(1)=Inf;
    fprintf('Fusion des deux symboles les moins fr�quents:\n');
    fprintf(print_format,p);
end
%%% Etape 2: on construit les mots de code � partir de la racine.
code=cell(2*n-1,1);
code{2*n-1}='';
for k=(2*n-1):-1:(n+1),
    for i=1:2,
        child=children_table(k,i);
         if i==1,
             code{child}=[code{k} '0']; % LIGNE A EDITER
         else
             code{child}=[code{k} '1']; % LIGNE A EDITER
         end
    end
end
code = code(1:n);

for i=1:n,
fprintf('%s:\t%s\n',symbols{i},code{i});
end

endfunction
