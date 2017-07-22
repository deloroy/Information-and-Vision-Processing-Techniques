function code=shannon(p,symbols)
% construit un code de shannon les symboles de symbols de probabilités p
if size(p,2)~=1,
    error('p must be a column vector');
end
n=length(p);

% On trie les probabilités par ordre croissant 
% (remarque : après le premier appel récursif la liste est déjà bien triée)
[p, I]=sort(p,'ascend');
code=cell(n,1);

if n==1, %le code du caractère est déjà unique
   code{1}=''; 
else,
   if n==2, %il n'y a que deux caractères à distinguer
      code{1}='0';
      code{2}='1';
   else,
         %on trouve une bonne coupe pour partager en deux les caractères
         %et on rappelle shannon récursivement sur chacune des 2 parties
         
         %"Meilleure" coupe(facultatif)
         cut=1; %cut est le numéro du premier caractère de la deuxième partie
         sum_proba_before=0; %somme des probabilités avant la coupe
         sum_proba_after=sum(p); %somme des probabilités après la coupe
         ecart_min=abs(sum_proba_after-sum_proba_before); #écart entre les 2 groupes
         for k=2:n, 
             sum_proba_before+=p(k-1);
             sum_proba_after-=p(k-1);
             ecart=abs(sum_proba_after-sum_proba_before);
             if ecart<ecart_min, % alors c'est une meilleure coupe
                cut=k;
                ecart_min=ecart;
             end
         end
                  
         %Appels récursifs sur les deux ensembles de caractères
         code_before_cut=shannon(p(1:cut-1),symbols);
         code_after_cut=shannon(p(cut:n),symbols);
         for i=1:cut-1,
             code{i}=['0' code_before_cut{i}];
         end
         for j=cut:n,
             code{j}=['1' code_after_cut{j-cut+1}];
         end
   end
end

% On retourne les codes correspondant aux bons caractères (on avait trié la liste !)
code2=cell(n,1);
for i=1:n,
    code2{I(i)}=code{i};
end
code=code2;

endfunction
