%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BME 772: LAB 1: Synchronized Averaging for Noise Reduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%M1 = Starting index of the signal
%M2 = Last index of the signal
%N  = Length of the signals
%function works all you need to do is make the report
function [SNR, final, M] =BME772_lab1(M1,M2,N)
M=M2-M1+1;
%%%%%%%%%%%%%%%%%%%%%%%%%LOADING THE SIGNALS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sig_mat(M,N)=0; %initialize matrix to store the signals
%load and store the signals into the matrix
for i = M1:M2
   i1 = int2str(i);
   sig_mat(i,:) = load (strcat('E',i1,i1));
end
%%%%%%%%%%%%%%%%%%%%%%%%% AVERAGING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the signal average
AVG_sig = sum(sig_mat)/M; %signal average
subplot(2,1,1)
time = (0:(length(AVG_sig)-1))./1000; %time axis
% plot a sample signal for comparison with the averaged signal
for z = M1:M2
   plot(time,sig_mat(z,:));
   hold on
end
axis('tight');
xlabel('Time (s)', 'Fontsize', 20, 'Interpreter','latex')
ylabel('y(n)', 'Fontsize', 20,'Interpreter','latex')
title(M + " Raw Signals used for Synchronized Average Signal", 'Fontsize', 20, 'Interpreter','latex');
hold off
lgd1 = legend('Location','eastoutside');
subplot(2,1,2)
plot(time,AVG_sig)
title("Synchronized Average Signal for " + M + " Signals", 'Fontsize', 20,'Interpreter','latex');
xlabel('Time (s)', 'Fontsize', 20, 'Interpreter','latex')
ylabel('$\bar{y}$ (n)','Fontsize', 20, 'Interpreter','latex')
% plot the synchronized averaged signal
axis('tight');
legend('Location', 'eastoutside');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SNR_COMPUTATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
np=0; % Initialize noise power
sp=0; % Initialize signal power
np = (sig_mat - AVG_sig).^2;
  % compute noise power
np = sum(np,"all");
np=np/(N*.001*(M-1));  % compute noise power already squared
sp = sum(AVG_sig.^2,"all")*(1/(N*0.001))- np/M; % compute signal power
SNR = sp/np; % compute SNR
%%%%%%%%%%%%%%%%%%%%%%%%%%%% EUCLIDEAN_DISTANCE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D=0;
d=0;
matr(1,M) = 0;
for i = 1:M
   Yn = sig_mat(i,:) - AVG_sig;
   Yn = Yn.^2;
   Yn = sum(Yn,'all');
   matr(1,i) = sqrt(Yn);
end
final = sum(matr,'all')/M;
end
