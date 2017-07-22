function result=PSNR(I,I_app)
#calcule le PSNR (Peak Signal to Noise Ratio) pour mesurer la qualité d'approximation
#de l'image I par l'image I_app

[height,width]=size(I);
diff = I-I_app;
result = 10*log10(height*width*max(I.*I)/sum(diff.*diff));

end