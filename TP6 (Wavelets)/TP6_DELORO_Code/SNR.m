function result=SNR(I,I_app)
#calcule le SNR (Signal to Noise Ratio) pour mesurer la qualité d'approximation
#de l'image I par l'image I_app

diff = I-I_app;
result = 10*log10(sum(I.*I)/sum(diff.*diff));

end