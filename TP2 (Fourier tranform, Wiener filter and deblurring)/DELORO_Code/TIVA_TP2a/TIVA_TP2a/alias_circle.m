N=1800; %% set N to 3600, 1800 or 900
x=((1:N)-(N/2))./N;
[X,Y]=meshgrid(x,x);
%Z=sin(200*((2*X).^3+(2*Y).^3));
Z=sin(200*(X.^2+Y.^2));

colormap('gray'); %% Sets the colormap to gray levels
for k=6:6:120,
    %k=fliplr([720,360,180,144,72,36,30,25,24,20,18,16,15,12,10,8,6]);
    %k=fliplr([360,180,72,36,30,25,24,20,18,15,12,10,8,6])
    %k=fliplr([180,36,30,25,20,18,15,12,10,6])
    ZZ=Z((k:k:N),(k:k:N));
    figure(1)    %Ouvre la figure 1
    imagesc(ZZ); %Affiche l'image
    axis equal;  %Contraint les axes à être orthonormés
    axis off;    %Efface les axes
    pause();     %Met l'exécution du code en pause jusqu'à ce qu'on
                 % presse la barre d'espacement
end 