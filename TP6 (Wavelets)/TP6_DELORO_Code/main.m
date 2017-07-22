% PARTIE I - Visualisation des ondelettes 2D

% question 2

% famille d'ondelettes
ondelettes={'Haar', 'Beylkin', 'Coiflet', 'Daubechies','Symmlet', 'Vaidyanathan','Battle'};

% filtre miroir associé aux ondelettes de Daubechies 4
qmf=MakeONFilter(ondelettes(4),4);
bar(qmf);

% transformée en ondelettes de Daubechies 4 et reconstruction de l'image par transformée inverse
% pow(2,L) est le niveau de résolution le plus grossier

L = 4;
I = ReadImage('Daubechies');
W = FWT2_PO(I,L,qmf);
IW = IWT2_PO(W,L,qmf);

% question 4

% image 2D à la résolution (256,256) correspondant aux ondelettes mères 
% des espaces de détails de type k=1,2,3 aux niveaux d'échelle j=1 (fin) et j=4 (grossier)

W_mother_1_low = zeros(size(W)); %niveau fin j=1
W_mother_1_low(1:2^7,2^7+1:2^8)=W(1:2^7,2^7+1:2^8);
IW_mother_1_low = IWT2_PO(W_mother_1_low,L,qmf);

W_mother_2_low = zeros(size(W));
W_mother_2_low(2^7+1:2^8,1:2^7)=W(2^7+1:2^8,1:2^7);
IW_mother_2_low = IWT2_PO(W_mother_2_low,L,qmf);

W_mother_3_low = zeros(size(W));
W_mother_3_low(2^7+1:2^8,2^7+1:2^8)=W(2^7+1:2^8,2^7+1:2^8);
IW_mother_3_low = IWT2_PO(W_mother_3_low,L,qmf);

W_mother_1_high = zeros(size(W)); %niveau grossier j=4
W_mother_1_high(1:2^4,2^4+1:2^5)=W(1:2^4,2^4+1:2^5);
IW_mother_1_high = IWT2_PO(W_mother_1_high,L,qmf);

W_mother_2_high = zeros(size(W));
W_mother_2_high(2^4+1:2^5,1:2^4)=W(2^4+1:2^5,1:2^4);
IW_mother_2_high = IWT2_PO(W_mother_2_high,L,qmf);

W_mother_3_high = zeros(size(W));
W_mother_3_high(2^4+1:2^5,2^4+1:2^5)=W(2^4+1:2^5,2^4+1:2^5);
IW_mother_3_high = IWT2_PO(W_mother_3_high,L,qmf);

clf; 
subplot(231);
imagesc(IW_mother_1_low);
colormap('gray');
title("Espace de détail j=1 (fin), k=1");
subplot(232);
imagesc(IW_mother_2_low);
colormap('gray');
title("Espace de détail j=1 (fin), k=2");
subplot(233);
imagesc(IW_mother_3_low);
colormap('gray');
title("Espace de détail j=1 (fin), k=3");
subplot(234);
imagesc(IW_mother_1_high);
colormap('gray');
title("Espace de détail j=4 (grossier), k=1");
subplot(235);
imagesc(IW_mother_2_high);
colormap('gray');
title("Espace de détail j=4 (grossier), k=2");
subplot(236);
imagesc(IW_mother_3_high);
colormap('gray');
title("Espace de détail j=4 (grossier), k=3");

% question 5

% transformée en ondelettes inverse d'une matrice W contenant un seul coefficient non nul égal à 1

W_zero_without_one = zeros(size(W));
W_zero_without_one(2^7,2^7)=1;
IW_zero_without_one = IWT2_PO(W_zero_without_one,L,qmf);

clf; 
surf(IW_zero_without_one);
colormap('copper');
title("Transformée inverse en ondelette de Daubechies 4 d'une matrice W contenant un seul coefficient non nul égal à 1");

% image associée à l'ondelette père au centre de l'image au niveau d'échelle j=1 (résolution 2^7)

W_father_1 = zeros(size(W));
W_father_1(2^3,2^3)=W(2^3,2^3);
W_father_1(2^7,2^7+2^6)=W(2^7,2^7+2^6);
W_father_1(2^7+2^6,2^7)=W(2^7+2^6,2^7);
W_father_1(2^7+2^6,2^7+2^6)=W(2^7+2^6,2^7+2^6);
IW_father_1 = IWT2_PO(W_father_1,L,qmf);

clf; 
surf(IW_father_1);
colormap('copper');
title("Ondelette père de Daubechies 4 au centre de l'image appartenant à l'espace d'échelle j=1");


% question 6

%images associés aux ondelettes mères du centre de l'image
%des espaces de détails aux niveaux d'échelle le plus fin (low) et le plus grossier (high)

%pour la transformée en ondelettes de Haar :
%qmf2=MakeONFilter(ondelettes(1));
%pour la transformée en Symmlet 8 :
qmf2=MakeONFilter(ondelettes(5),8);

W2 = FWT2_PO(I,L,qmf2);

%espace de détail 1
W_low_1 = zeros(size(W2));
W_low_1(2^6,2^7+2^6)=W2(2^6,2^7+2^6);
W_high_1 = zeros(size(W2));
W_high_1(2^3,2^4+2^3)=W2(2^3,2^4+2^3);
IW_low_1 = IWT2_PO(W_low_1,L,qmf2);
IW_high_1 = IWT2_PO(W_high_1,L,qmf2);

%espace de détail 2
W_low_2 = zeros(size(W2)); %niveau le plus fin
W_low_2(2^7+2^6,2^6)=W2(2^7+2^6,2^6); %niveau le plus grossier
W_high_2 = zeros(size(W2));
W_high_2(2^4+2^3,2^3)=W2(2^4+2^3,2^3);
IW_low_2 = IWT2_PO(W_low_2,L,qmf2);
IW_high_2 = IWT2_PO(W_high_2,L,qmf2);

%espace de détail 3
W_low_3 = zeros(size(W2));
W_low_3(2^7+2^6,2^7+2^6)=W2(2^7+2^6,2^7+2^6);
W_high_3 = zeros(size(W2));
W_high_3(2^4+2^3,2^4+2^3)=W2(2^4+2^3,2^4+2^3);
IW_low_3 = IWT2_PO(W_low_3,L,qmf2);
IW_high_3 = IWT2_PO(W_high_3,L,qmf2);

clf; 
subplot(231);
surf(IW_low_1);
colormap('copper');
title("Espace de détail j=1 (fin), k=1");
subplot(232);
surf(IW_low_2);
colormap('copper');
title("Espace de détail j=1 (fin), k=2");
subplot(233);
surf(IW_low_3);
colormap('copper');
title("Espace de détail j=1 (fin), k=3");
subplot(234);
surf(IW_high_1);
colormap('copper');
title("Espace de détail j=4 (grossier), k=1");
subplot(235);
surf(IW_high_2);
colormap('copper');
title("Espace de détail j=4 (grossier), k=2");
subplot(236);
surf(IW_high_3);
colormap('copper');
title("Espace de détail j=4 (grossier), k=3");

     
% PARTIE II - Débruitage d'image

% question 2

% bruitage de l'image
sigma = 20.;
noise = sigma*randn(size(I));
I_noised = I + noise;

clf; subplot(121);
GrayImage(I);

subplot(122);
GrayImage(I_noised);

% question 3

% débruitage en passant par les ondelettes
% on enlève les coefficients d'amplitude inférieure au seuil theta passé en indice
% de wavelet_denoise

theta = 0 : 1 : 100;
N=length(theta);
SNR_theta = zeros(1,N); % SNR en fonction de theta
PSNR_theta = zeros(1,N); % PSNR en fonction de theta

I_denoised=zeros(size(I_noised));

for k=1:N,
    th=theta(k);
    I_denoised=wavelet_denoise(I_noised,th);
    SNR_theta(1,k) = SNR(I,I_denoised); 
    PSNR_theta(1,k) = PSNR(I,I_denoised); 
end

clf; subplot(121);
plot(theta,SNR_theta(1,:),"b");
xlabel("theta")
ylabel("SNR")

subplot(122);
plot(theta,PSNR_theta(1,:),"r");
xlabel("theta")
ylabel("PSNR")


% affichage de l'image débruitée avec le meilleur theta obtenu après tracé de la courbe

clf; subplot(121);
GrayImage(wavelet_denoise(I_noised,65));

subplot(122);
GrayImage(wavelet_denoise(I_noised,70));


% question 4

% débruitage en moyennant les résultats de wavelet_denoise sur des translations de l'image

theta = 0 : 10 : 100;
nb_transl = [1,2,4,8];
N=length(theta);
SNR_theta = zeros(4,N); % SNR en fonction de m et de theta
PSNR_theta = zeros(4,N); % PSNR en fonction de m et de theta

I_denoised=zeros(size(I_noised));

for k=1:N,
    th=theta(k);
    for l=1:4,
        m=nb_transl(l);
        disp(m);
        I_denoised=all_shifts_denoising(I_noised,th,m);
        SNR_theta(l,k) = SNR(I,I_denoised); 
        PSNR_theta(l,k) = PSNR(I,I_denoised); 
    end
end

clf; subplot(121);
hold on;
plot(theta,SNR_theta(1,:));
plot(theta,SNR_theta(2,:));
plot(theta,SNR_theta(3,:));
plot(theta,SNR_theta(4,:));
holf off;
xlabel("theta")
ylabel("SNR")

subplot(122);
hold on;
plot(theta,PSNR_theta(1,:));
plot(theta,PSNR_theta(2,:));
plot(theta,PSNR_theta(3,:));
plot(theta,PSNR_theta(4,:));
hold off;
xlabel("theta")
ylabel("PSNR")
