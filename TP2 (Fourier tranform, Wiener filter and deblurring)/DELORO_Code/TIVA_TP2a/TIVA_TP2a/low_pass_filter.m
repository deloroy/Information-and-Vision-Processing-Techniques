function F=low_pass_filter(h,w,fc)
#building a low-pass filter for h*w dimensions and fc cut-off frequency, 
#adapted for images whose low-frequences have been previously shifted at the middle

freq_x=1:w;
freq_x=ceil(w*(1-fc)/2.)<freq_x & freq_x<ceil(w*(1+fc)/2.); #1D low-pass filter
freq_y=1:h;
freq_y=ceil(h*(1-fc)/2.)<freq_y & freq_y<ceil(h*(1+fc)/2.);
F=freq_y'*freq_x;  #2D low-pass filter

end