%% using lab4data
% perform pitch detection using the male and female signals
%% load signals
sounddata = load("lab4data.mat");
female = sounddata.FEMALES;
male = sounddata.MALE_S;
%formula is 1/(N - k) times the sum of s(n) times s(n + k)
% k is the lag (shift of the signal positive if right negative if left))
% k must start from 0 and end at the farthest shift
% N is total number of total samples
%% female section
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(female, 12500);
figure(1)
subplot(3,1,1)
plot(female)
xlabel('Time samples')
ylabel('Amplitude')
title('Orignal Female Sound Sample')
subplot(3,1,2)
xzr = (0:(length(results)-1));
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Female Signal')
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
xlim([0,350])
fprintf('Female Pitch is %f Hz\n', pitchhz);
% female section
femalefft = fft(female);
subplot(3,1,3)
plot(abs(femalefft(1:3000)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Female Signal')
[F1 ,locs1] = findpeaks(abs(femalefft(1:500)), 'MinPeakDistance', 25);
[F1final, lowerbound, upperbound] = findformant(F1, locs1);
Formant1 = sum(F1final)/length(F1final);
hold on
rectangle('position', [(lowerbound - 10) 0 round((upperbound-lowerbound)+ 20) max(F1)*1.1]);
[F2 ,locs2] = findpeaks(abs(femalefft(751:1250)), 'MinPeakDistance', 25);
[F2final, lowerbound, upperbound] = findformant(F2, locs2);
lowerbound = lowerbound + 750;
upperbound = upperbound + 750;
Formant2 = sum(F2final)/length(F2final);
hold on
rectangle('position', [(lowerbound-10) 0 round((upperbound-lowerbound)+ 20) max(F2)*1.1]);
[F3 ,locs3] = findpeaks(abs(femalefft(1751:2250)), 'MinPeakDistance', 25);
[F3final, lowerbound, upperbound] = findformant(F3, locs3);
lowerbound = lowerbound + 1750;
upperbound = upperbound + 1750;
Formant3 = sum(F3final)/length(F3final);
hold on
rectangle('position', [(lowerbound-10) 0 round((upperbound-lowerbound)+ 20) max(F3)*1.1]);
[F4 ,locs4] = findpeaks(abs(femalefft(2501:3000)), 'MinPeakDistance', 25);
[F4final, lowerbound, upperbound] = findformant(F4, locs4);
lowerbound = lowerbound + 2500;
upperbound = upperbound + 2500;
Formant4 = sum(F4final)/length(F4final);
hold on
rectangle('position', [(lowerbound-10) 0 round((upperbound-lowerbound)+ 20) max(F4)*1.1]);
%% male section
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(male, 12500);
figure(2)
subplot(3,1,1)
plot(male)
xlabel('Time samples')
ylabel('Amplitude')
title('Orignal Male Sound Sample')
xzr = (0:(length(results)-1));
subplot(3,1,2)
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Male Signal')
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
xlim([0,350])
fprintf('Male Pitch is %f Hz\n', pitchhz);
hold off
% male section
malefft = fft(male);
subplot(3,1,3)
plot(abs(malefft(1:3000+1)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Male Signal')
[F1 ,locs1] = findpeaks(abs(malefft(1:500)), 'MinPeakDistance', 25);
[F1final, lowerbound, upperbound] = findformant(F1, locs1);
mFormant1 = sum(F1final)/length(F1final);
hold on
rectangle('position', [(lowerbound - 10) 0 round((upperbound-lowerbound)+ 20) max(F1)*1.1]);
[F2 ,locs2] = findpeaks(abs(malefft(501:1000)), 'MinPeakDistance', 25);
[F2final, lowerbound, upperbound] = findformant(F2, locs2);
lowerbound = lowerbound + 500;
upperbound = upperbound + 500;
mFormant2 = sum(F2final)/length(F2final);
hold on
rectangle('position', [(lowerbound-10) 0 round((upperbound-lowerbound)+ 20) max(F2)*1.1]);
[F3 ,locs3] = findpeaks(abs(malefft(1001:1500)), 'MinPeakDistance', 25);
[F3final, lowerbound, upperbound] = findformant(F3, locs3);
lowerbound = lowerbound + 1000;
upperbound = upperbound + 1000;
mFormant3 = sum(F3final)/length(F3final);
hold on
rectangle('position', [(lowerbound-10) 0 round((upperbound-lowerbound)+ 20) max(F3)*1.1]);
[F4 ,locs4] = findpeaks(abs(malefft(1501:2000)), 'MinPeakDistance', 25);
[F4final, lowerbound, upperbound] = findformant(F4, locs4);
lowerbound = lowerbound + 1500;
upperbound = upperbound + 1500;
mFormant4 = sum(F4final)/length(F4final);
hold on
rectangle('position', [(lowerbound-10) 0 round((upperbound-lowerbound)+ 20) max(F4)*1.1]);
%% function check
[asf, lag] = xcorr(female, 'unbiased');
figure(3);
plot(lag, asf);
xlim([0,350])
[asf, lag] = xcorr(male, 'unbiased');
figure(4);
plot(lag, asf);
xlim([0,350])
%% repeat for all samples
%% vowel a (female)
[femaleVa, fsa] = audioread('female_a.wav');
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(femaleVa, fsa);
figure(5)
subplot(3,1,1)
plot(femaleVa);
xlabel('Time samples')
ylabel('Amplitude')
title('Vowel A (Female) Sound Sample')
subplot(3,1,2)
xzr = (0:(length(results)-1));
subplot(3,1,2)
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Vowel A (Female) Signal')
xlim([0,500])
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
hold off
femaleVafft = fft(femaleVa);
subplot(3,1,3)
plot(abs(femaleVafft(1:512)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Vowel A (Female) Signal')
fprintf('Female Pitch (Vowel A) is %f Hz\n', pitchhz);
hold on
[pks1, locisfva1] = findpeaks(abs(femaleVafft(1:150)), 'MinPeakDistance', 25);
finder = find(pks1 == max(pks1));
plot(locisfva1(finder), max(pks1), 'o')
[pks2, locisfva2] = findpeaks(abs(femaleVafft(201:350)), 'MinPeakDistance', 25);
finder2 = find(pks2 == max(pks2));
plot((200 + locisfva2(finder2)), max(pks2),'o')
[pks3, locisfva3] = findpeaks(abs(femaleVafft(401:550)), 'MinPeakDistance', 25);
finder3 = find(pks3 == max(pks3));
plot((400 + locisfva3(finder3)), max(pks3),'o')
fva = [max(pks1), max(pks2), max(pks3)];
hold off
%% vowel i (female)
[femaleVi, fsa] = audioread('female_i.wav');
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(femaleVi, fsa);
figure(6)
subplot(3,1,1)
plot(femaleVi);
xlabel('Time samples')
ylabel('Amplitude')
title('Vowel I (Female) Sound Sample')
subplot(3,1,2)
xzr = (0:(length(results)-1));
subplot(3,1,2)
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Vowel I (Female) Signal')
xlim([0,500])
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
hold off
femaleVifft = fft(femaleVi);
subplot(3,1,3)
plot(abs(femaleVifft(1:512)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Vowel A (Female) Signal')
fprintf('Female Pitch (Vowel I) is %f Hz\n', pitchhz);
hold on
[pks1, locisfvi1] = findpeaks(abs(femaleVifft(1:100)), 'MinPeakDistance', 25);
finder = find(pks1 == max(pks1));
plot(locisfvi1(finder), max(pks1), 'o')
[pks2, locisfvi2] = findpeaks(abs(femaleVifft(151:250)), 'MinPeakDistance', 25);
finder2 = find(pks2 == max(pks2));
plot((150 + locisfvi2(finder2)), max(pks2),'o')
[pks3, locisfvi3] = findpeaks(abs(femaleVifft(301:400)), 'MinPeakDistance', 25);
finder3 = find(pks3 == max(pks3));
plot((300 + locisfvi3(finder3)), max(pks3),'o')
fvi = [max(pks1), max(pks2), max(pks3)];
hold off
%% vowel u (female)
[femaleVu, fsa] = audioread('female_u.wav');
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(femaleVu, fsa);
figure(7)
subplot(3,1,1)
plot(femaleVu);
xlabel('Time samples')
ylabel('Amplitude')
title('Vowel U (Female) Sound Sample')
subplot(3,1,2)
xzr = (0:(length(results)-1));
subplot(3,1,2)
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Vowel U (Female) Signal')
xlim([0,500])
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
hold off
femaleVufft = fft(femaleVu);
subplot(3,1,3)
plot(abs(femaleVufft(1:512)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Vowel U (Female) Signal')
fprintf('Female Pitch (Vowel U) is %f Hz\n', pitchhz);
hold on
[pks1, locisfvu1] = findpeaks(abs(femaleVufft(1:150)), 'MinPeakDistance', 25);
finder = find(pks1 == max(pks1));
plot(locisfvu1(finder), max(pks1), 'o')
[pks2, locisfvu2] = findpeaks(abs(femaleVufft(201:350)), 'MinPeakDistance', 25);
finder2 = find(pks2 == max(pks2));
plot((200 + locisfvu2(finder2)), max(pks2),'o')
[pks3, locisfvu3] = findpeaks(abs(femaleVufft(401:500)), 'MinPeakDistance', 25);
finder3 = find(pks3 == max(pks3));
plot((400 + locisfvu3(finder3)), max(pks3),'o')
fvu = [max(pks1), max(pks2), max(pks3)];
hold off
%% vowel a (male)
[maleVa, fsa] = audioread('male_a.wav');
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(maleVa, fsa);
figure(8)
subplot(3,1,1)
plot(maleVa);
xlabel('Time samples')
ylabel('Amplitude')
title('Vowel A (Male) Sound Sample')
subplot(3,1,2)
xzr = (0:(length(results)-1));
subplot(3,1,2)
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Vowel A (Male) Signal')
xlim([0,500])
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
hold off
maleVafft = fft(maleVa);
subplot(3,1,3)
plot(abs(maleVafft(1:512)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Vowel A (Male) Signal')
fprintf('Male Pitch (Vowel A) is %f Hz\n', pitchhz);
hold on
[pks1, locismva1] = findpeaks(abs(maleVafft(1:100)), 'MinPeakDistance', 25);
finder = find(pks1 == max(pks1));
plot(locismva1(finder), max(pks1), 'o')
[pks2, locismva2] = findpeaks(abs(maleVafft(151:250)), 'MinPeakDistance', 25);
finder2 = find(pks2 == max(pks2));
plot((150 + locismva2(finder2)), max(pks2),'o')
[pks3, locismva3] = findpeaks(abs(maleVafft(301:400)), 'MinPeakDistance', 25);
finder3 = find(pks3 == max(pks3));
plot((300 + locismva3(finder3)), max(pks3),'o')
mva = [max(pks1), max(pks2), max(pks3)];
hold off
%% vowel i (male)
[maleVi, fsa] = audioread('male_i.wav');
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(maleVi, fsa);
figure(9)
subplot(3,1,1)
plot(maleVi);
xlabel('Time samples')
ylabel('Amplitude')
title('Vowel I (Male) Sound Sample')
subplot(3,1,2)
xzr = (0:(length(results)-1));
subplot(3,1,2)
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Vowel I (Male) Signal')
xlim([lowerbound - 100,upperbound + 600])
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
hold off
maleVifft = fft(maleVi);
subplot(3,1,3)
plot(abs(maleVifft(1:512)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Vowel I (Male) Signal')
fprintf('Male Pitch (Vowel I) is %f Hz\n', pitchhz);
hold on
[pks1, locismvi1] = findpeaks(abs(maleVifft(1:150)), 'MinPeakDistance', 25);
finder = find(pks1 == max(pks1));
plot(locismvi1(finder), max(pks1), 'o')
[pks2, locismvi2] = findpeaks(abs(maleVifft(201:350)), 'MinPeakDistance', 25);
finder2 = find(pks2 == max(pks2));
plot((200 + locismvi2(finder2)), max(pks2),'o')
[pks3, locismvi3] = findpeaks(abs(maleVifft(401:550)), 'MinPeakDistance', 25);
finder3 = find(pks3 == max(pks3));
plot((400 + locismvi3(finder3)), max(pks3),'o')
mvi = [max(pks1), max(pks2), max(pks3)];
hold off
%% vowel u (male)
[maleVu, fsa] = audioread('male_u.wav');
[results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(maleVu, fsa);
figure(10)
subplot(3,1,1)
plot(maleVu);
xlabel('Time samples')
ylabel('Amplitude')
title('Vowel U (Male) Sound Sample')
subplot(3,1,2)
xzr = (0:(length(results)-1));
subplot(3,1,2)
plot(xzr, results)
xlabel('Time lag')
ylabel('Autocorrelation coefficient')
title('Autocorrelation of Vowel U (Male) Signal')
xlim([lowerbound - 100,upperbound + 600])
hold on
rectangle('Position',[lowerbound pkheightL (upperbound - lowerbound) (pkheight - pkheightL)])
hold off
maleVufft = fft(maleVu);
subplot(3,1,3)
plot(abs(maleVufft(1:512)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Fast Fourier Transform of Vowel U (Male) Signal')
fprintf('Male Pitch (Vowel U) is %f Hz\n', pitchhz);
hold on
[pks1, locismvu1] = findpeaks(abs(maleVufft(1:150)), 'MinPeakDistance', 25);
finder = find(pks1 == max(pks1));
plot(locismvu1(finder), max(pks1), 'o')
[pks2, locismvu2] = findpeaks(abs(maleVufft(201:350)), 'MinPeakDistance', 25);
finder2 = find(pks2 == max(pks2));
plot((200 + locismvu2(finder2)), max(pks2),'o')
[pks3, locismvu3] = findpeaks(abs(maleVufft(401:550)), 'MinPeakDistance', 25);
finder3 = find(pks3 == max(pks3));
plot((400 + locismvu3(finder3)), max(pks3),'o')
mva = [max(pks1), max(pks2), max(pks3)];
hold off
%% pitch period plot
maler = 1./[171.23];
maler2 = 1./[ 90.58];
maler3 = 1./[100.200];
maler4 = 1./[104.821];
femaler = 1./[204.91];
femaler2 = 1./[243.90];
femaler3 = 1./[251.26];
femaler4 = 1./[252.52];
scatter(femaler, maler, 'filled');
hold on
scatter(femaler2, maler2, 'filled');
scatter(femaler3, maler3, 'filled');
scatter(femaler4, maler4, 'filled');
legend('Original', 'Vowel A', 'Vowel I','Vowel U')
hold off
xlabel('Female Pitch Period')
ylabel('Male Pitch Period')
title('Female Pitch Period vs Male Pitch Period')
%%
%function begins from a lag of 0
function [results, pitchhz, lowerbound, upperbound, pkheight,pkheightL] = autocorrelation(signal, fs)
results  = zeros(1, length(signal));
   for i = 0:length(signal)-1 %needs two for loops outer for loop is to iterate it from lags 0 to end (female is 0 to 6600 for a total of 6601 items anything greater leads to redundant results)
       summing = 0; %setting up the summing section
       for x = 1:length(signal) %makes up the summing section of the lab which is the signal multiplied by the signal with the shift
           if (x + i) > length(signal)
               summing = summing + 0;
           else
               summing = summing + signal(x)*signal(x+i);
           end
       end
      
       cofff = 1/(length(signal) - i);
       results(1, i+ 1) = cofff*summing;
   end
   [pks, locis] = findpeaks(results, "MinPeakHeight",results(1)/2.5, 'MinPeakDistance',fs*0.003); %makes sure that there is a height restriction and distance restriciton
   xr1 = max(pks);
   xrr1 = find(pks == xr1);
   locco = locis(xrr1);
   pks(xrr1) = [];
   locis(xrr1) = [];
   xr2 = max(pks);
   xrr2 = find(pks == xr2);
   locco2 = locis(xrr2);
   pks(xrr2) = [];
   locis(xrr2) = [];
   if locco < locco2
       lowerbound = locco;
       upperbound = locco2;
   else
       lowerbound = locco2;
       upperbound = locco;
   end
   pitchperiod = (upperbound - lowerbound); %picth period in samples
   pitchhz = fs/pitchperiod;
   pkheight = max(xr1, xr2);
   pkheightL = min(xr1, xr2);
 
end
function [F1final, lowerbound, upperbound] = findformant(F1, locs1)
   F1final = zeros(1,3);
    lowerbound = 0;
    upperbound = 0;
    for i = 1:3
        F1final(i) = max(F1);
        index = find(F1 == max(F1));
        F1(index) = [];
        if lowerbound == 0
            lowerbound = locs1(index);
            locs1(index) = [];
            upperbound = lowerbound;
        elseif lowerbound > locs1(index)
            lowerbound = locs1(index);
            locs1(index) = [];
        elseif upperbound < locs1(index)
            upperbound = locs1(index);
            locs1(index) = [];
        end
    end
end
