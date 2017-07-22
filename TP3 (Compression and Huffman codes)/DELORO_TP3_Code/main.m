%TP3 - COMPRESSION SANS PERTES ET CODES DE HUFFMAN

load('english_letter_frequencies');
bar(p);
N=length(p);

%1. Compression d'une séquence de caractères

%Arbre associé au code de Huffmann
huffman_tree(p',S);

%Encodage des caractères avec Huffman
code=huffman(p',S);

%Calcul de l'entropie de la distribution
entropy=-log2(p)*p';

%Longueur moyenne du code de Huffman
len = @(k)(length(code{k}));
lengths= arrayfun(@(k){len(k)},1:N);
lengths=cell2mat(lengths);
mean_length=lengths*p';

%Taux de compression de Huffman par rapport à un encodage 
%qui attribuerait un nombre identique de bits à 
%chaque lettre
length_naive=ceil(log2(N));
rate_compress=abs(length_naive-mean_length)/length_naive;

%Longueur moyenne d'un code de Shannon et taux de compression
mean_length_Shannon=-floor(log2(p))*p';
rate_compress_Shannon=abs(length_naive-mean_length_Shannon)/length_naive;

%Bonus : encodage des caractères avec un code Shannon
code_Shannon=shannon(p',S);

%2. Compression par blocs

%Création de l'alphabet des symboles
N2=N*N; %taille du nouvel alphabet
S2=cell(N2,1);
for i=1:N
   for j=1:N
      S2{(i-1)*N+j}=[S{i} S{j}];
   end
end  


%Fréquences associées aux symboles (supposant les variables i.i.d.)
p2=zeros(1,N2)
for i=1:N
   for j=1:N
      p2(1,(i-1)*N+j)=p(1,i)*p(1,j);
   end
end

%Encodage des caractères avec Huffman
code2=huffman(p2',S2);

%Calcul de l'entropie de la distribution
entropy2=-log2(p2)*p2';

%Longueur moyenne du code de Huffman
len2 = @(k)(length(code2{k}));
lengths2= arrayfun(@(k){len2(k)},1:N2);
lengths2=cell2mat(lengths2);
mean_length2=lengths2*p2';
mean_length2/=2; %longueur moyenne par lettre (pour comparer avec 1.)

%Taux de compression de Huffman par rapport à un encodage 
%qui attribuerait un nombre identique de bits à 
%chaque paire de lettres
length_naive2=ceil(log2(N2))/2.;
rate_compress2=abs(length_naive2-mean_length2)/length_naive2;

%Longueur moyenne d'un code de Shannon et taux de compression
mean_length_Shannon2=-floor(log2(p2))*p2';
mean_length_Shannon2/=2.;
rate_compress_Shannon2=abs(length_naive2-mean_length_Shannon2)/length_naive2;