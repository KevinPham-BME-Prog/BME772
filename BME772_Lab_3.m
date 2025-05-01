%Lab 3: QRS Detection and ECG Rhythm Analysis
%close all active varibles
clear all
close all
%open signals
useecg = load('ECG3.txt');
useecg =useecg/1000;
%perform the various filtering procedure that forms the Pan-tompkins
%algorithm
[num_beats1, RR1, RRd1, QRS1, HR1, pic] = mylab(1, useecg, "ECG3")
useecg = load('ECG4.txt');
useecg =useecg/1000;
[num_beats2, RR2, RRd2, QRS2, HR2, pic] = mylab(pic, useecg, "ECG4")
useecg = load('ECG5.txt');
useecg =useecg/1000;
[num_beats3, RR3, RRd3, QRS3, HR3, pic] = mylab(pic, useecg, "ECG5")
useecg = load('ECG6.txt');
useecg =useecg/1000;
[num_beats4, RR4, RRd4, QRS4, HR4, pic] = mylab(pic, useecg, "ECG6")
function [num_beats, RR, RRd, QRS, HR, pic] = mylab(pic, useecg, name)
   %% orignal
   fs = 200;
   slen = (1:length(useecg))./fs;
   figure(pic)
   pic = pic +1;
   plot(slen,useecg);
   title("Unfiltered "+ name)
   xlabel("Time (s)")
   ylabel("Amplitude")
   print("Unfiltered_" + name, '-dpng');
   %% bandpass filter
  
   %consists of lowpass filter, highpass filter, removal of 60Hz interference (
   %baseline wander is removed
  
   %notch filter (removal of 60Hz)
   [bN] = [1, 0.618, 1];
   [aN] = [1,0,0];
   M = 128;
   figure(pic)
   pic = pic +1;
   zplane(bN,aN);
   print("Notch_Pole_Zero" + name, '-dpng');
   figure(pic)
   pic = pic +1;
   freqz(bN,aN,M,fs)
   print("Notch_Magnitude" + name, '-dpng');
  
   notch = filter(bN,aN,useecg);
   figure(pic)
   pic = pic +1;
   plot(slen,notch);
   title("Notch Plot for "+ name)
   xlabel("Time (s)")
   ylabel("Amplitude")
   print("Notch_" + name, '-dpng'); %fig 4
   %%
   fs = 200;
   %make lowpass filter of pan tompkins
   [bL] = [1, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1];
   [aL] = [1, -2, 1];
   lowpass = filter(bL,aL,notch);
  
  
   %highpass filter
   [bH] = [-1, zeros(1,15), 32, -32, zeros(1,14),1];
   [aH] = [32, -32];
  
  
   slen = (1:length(lowpass))./200;
   bandpass = filter(bH,aH,lowpass);
  
   %bandpass
   bBp = conv(bL,bH);
   aBp = conv(aL,aH);
   [HBp, wBp] = freqz(bBp,aBp, 1028, fs);
   figure(pic)
   pic = pic +1;
   zplane(bBp,aBp)
   print("Bandpass_Pole_" + name, '-dpng');
  
   figure(pic)
   pic = pic +1;
   subplot(2,1,1)
   plot(wBp, 20*log(abs(HBp)));
   title("Magnitude")
   xlabel("Frequency (Hz)")
   ylabel("Magnitude (dB)")
  
   subplot(2,1,2)
   plot(wBp, angle(HBp)*360/(2*pi))
   title("Phase")
   xlabel("Frequency (Hz)")
   ylabel("Phase (rad)")
   print("Bandpass_Magnitude_" + name, '-dpng');
   figure(pic)
   pic = pic +1;
   plot(slen,bandpass);
   xlabel("Time (s)")
   ylabel("Amplitude")
   title("Bandpass "+ name)
   print("Bandpass_" + name, '-dpng'); %7
   %% differentiator
   [bD] = 1/8*[2,1,0, -1,-2];
   [aD] = [1,0,0];
   figure(pic)
   pic = pic +1;
   zplane(bD, aD);
   print("Differentiator_pole_" + name, '-dpng');
  
   figure(pic)
   pic = pic +1;
   [Hd, wd] = freqz(bD,aD, 1028, fs);
   subplot(2,1,1)
   plot(wd, 20*log(abs(Hd)));
   title("Magnitude")
   xlabel("Frequency (Hz)")
   ylabel("Magnitude (dB)")
   subplot(2,1,2)
   plot(wd, angle(Hd)*360/(2*pi))
   title("Phase")
   xlabel("Frequency (Hz)")
   ylabel("Phase (rad)")
   print("Different_Magnitude_" + name, '-dpng');
   differen = filter(bD,aD,bandpass);
  
   figure(pic)
   pic = pic +1;
   plot(slen,differen);
   xlabel("Time (s)")
   ylabel("Amplitude")
   title("Differentiator " + name)
   print("Differentiator_" + name, '-dpng'); %10
  
   %% squaring operation (amplies values greater than 1 and reduces values less than 1)
   squared = differen.^2;
   figure(pic)
   pic = pic +1;
   plot(slen,squared);
   xlabel("Time (s)")
   ylabel("Amplitude")
   title("Squared " + name)
   print("Squared_" + name, '-dpng'); %11
  
   %% moving-window integrator N = 30 with sampling frequency = 200Hz
   [bW] = ones(1,30).*(1/30);
   [aW] = [1];
   MW = filter(bW,aW,squared);
   figure(pic)
   pic = pic +1;
   zplane(bW,aW)
   print("Moving_window_" + name, '-dpng');
   figure(pic)
   pic = pic +1;
   [hW, wW] = freqz(bW,aW,1028, fs);
   subplot(2,1,1)
   plot(wW, 20*log(abs(hW)));
   title("Magnitude")
   xlabel("Frequency (Hz)")
   ylabel("Magnitude (dB)")
  
   subplot(2,1,2)
   plot(wW, angle(hW)*360/(2*pi))
   title("Phase")
   xlabel("Frequency (Hz)")
   ylabel("Phase (rad)")
   print("MW_Magnitude_" + name, '-dpng');
  
   figure(pic)
   pic = pic +1;
   plot(slen,MW);
   findpeaks(MW,slen,'MinPeakHeight',20, 'MinPeakDistance',0.25);
   xlabel("Time (s)")
   ylabel("Amplitude")
   title("Moving Average " + name)
   print("Moving_average_" + name, '-dpng')
  
   [pks, locs, width] = findpeaks(MW,slen,'MinPeakHeight', 20, 'MinPeakDistance',0.25);
   num_beats = length(pks) -1;
   RR = mean(diff(locs(2:end)));
   RRd = std(diff(locs(2:end)));
   QRS = mean(width(2:end));
   HR = 60/RR;
end
