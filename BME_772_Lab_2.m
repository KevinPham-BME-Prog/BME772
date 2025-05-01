%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Lab 2: Filtering of the ECG for Noise and Artifact Removal     %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all               % clears all active variables
close all
% the ECG signal in the file is sampled at 1000 Hz
% lowpass filter the signal at 75 Hz and downsample by a factor of 5
% this will retain the 60 Hz noise but cause some aliasing artifacts
%
usecg = load('ecg_60hz.dat');
fs = 1000; %sampling rate
fsh = fs/2; %half the sampling rate
[b,a] = butter(12, 75/fsh);
% Butterworth filter frequency response
figure (1);
M = 512;
freqz(b, a, M, fs); %frequency response
print('butterworth_filter_FR','-dpng');
lpusecg = filter(b, a, usecg);
usecg = lpusecg;
clear lpusecg;
len = length(usecg);
k = 1;
for i = 1 : length(usecg)
   if (rem(i,5) == 0) %takes checks the remainder is 0
       ecg(k) = usecg(i);
       k = k+1;
   end
end
fs = 200; %effective sampling rate after downsampling
% Plot of the ECG before filtering
slen = length(ecg);
t = (1:slen)/fs;
figure (2)
plot(t, ecg)
xlabel('Time in seconds');
ylabel('ECG');
title('Unfiltered ECG Signal');
axis tight;
print('Unfiltered_ECG_Signal', '-dpng');
% Plot of the spectrum of the ECG before filtering
ecgft = fft(ecg);
ff= fix(slen/2) + 1;
maxft = max(abs(ecgft));
f = (1:ff)*fs/slen; % frequency axis up to fs/2.
ecgspec = 20*log10(abs(ecgft)/maxft);
figure (3)
plot(f, ecgspec(1:ff));
xlabel('Frequency in Hz');
ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of the original ECG');
axis tight;
print('Unfiltered_ECG_Spectrum', '-dpng');
%%
% define notch filter coefficient arrays a and b
count = 4;
[bN] = [1, 0.618, 1]; %this is the zeros of the transfer function
[aN] = [1,0,0] ; %this is the poles of the transfer function
wording = 'Notch';
M = 128;
% Notch filter frequency response (frequency response, ecg with filter,
% power spectrum)
myspectrum(bN,aN,M,fs,ecg,count,wording);
%%
[bH] = [0.25, 0.5, 0.25];
[aH] = [1,0,0];
wording = 'Hanning';
count = 7;
myspectrum(bH,aH,M,fs,ecg,count,wording);
%hanning filter (frequency response, ecg with filter, power spectrum)
%%
%deriative based filter
[bD] = [1, -1];
[aD] = [1 -0.995];
count = 10;
wording = 'Derivative';
myspectrum(bD,aD,M,fs,ecg,count,wording);
%frequency response, ecg with filter, power spectrum
%%
%combined
bC1 = conv(bN, bH);
bC = conv(bC1, bD);
aC1 = conv(aN, aH);
aC = conv(aC1, aD);
count = 13;
wording = 'Combined';
myspectrum(bC,aC,M,fs,ecg,count,wording);
%frequency response, ecg with filter, power spectrum
function plotssnum = myspectrum(b,a,M,fs,ecg,pic,wording) %needs b and a coefficients and the M, fs and signal data then provides the output
%wording is used to autogenerate the picture's title and save file
figure(pic)
freqz(b,a,M,fs)
pic = pic +1;
currentfilt = filter(b,a,ecg);
print(wording + "_filter_FR", '-dpng');
figure(pic)
slen = length(ecg);
t = (1:slen)/fs;
plot(t,currentfilt)
pic = pic +1;
xlabel('Time in seconds');
ylabel('ECG');
title(wording + " Filtered ECG Signal");
axis tight;
print(wording + "_ECG_Signal", '-dpng');
ecgft = fft(currentfilt);
ff= fix(slen/2) + 1;
maxft = max(abs(ecgft));
f = (1:ff)*fs/slen; % frequency axis up to fs/2.
ecgspec = 20*log10(abs(ecgft)/maxft);
figure (pic)
plot(f, ecgspec(1:ff));
xlabel('Frequency in Hz');
ylabel('Log Magnitude Spectrum (dB)');
title("Spectrum of the " + wording + " Filtered ECG");
axis tight;
print(wording + "_filtered_ECG_Spectrum", '-dpng');
plotsnum = pic+1;
end
