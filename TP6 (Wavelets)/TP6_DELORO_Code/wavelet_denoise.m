function denoised_I=wavelet_denoise(I,th)
% débruite l'image en enlevant les coefficients d'amplitude inférieure à th
% de la transformée en ondelette de l'image bruitée I

% famille d'ondelettes
ondelettes={'Haar', 'Beylkin', 'Coiflet', 'Daubechies','Symmlet', 'Vaidyanathan','Battle'};

% filtre miroir associé aux ondelettes de Daubechies 4
qmf=MakeONFilter(ondelettes(4),4);

% transformée en ondelettes périodisées
% résolution la plus grossière : pow(2,L)
L = 4; 
W = FWT2_PO(I,L,qmf);

% on annule les coefficients d'amplitude inférieure à th
tmp = abs(W) >= th;
tmp = tmp./1.;
W = W.*tmp;

% transformée inverse
denoised_I = IWT2_PO(W,L,qmf);

end