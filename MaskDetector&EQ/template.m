[kick,kfs]=audioread('tracks/01_KickIn.wav');
[bass,bfs]=audioread('tracks/04_Tom1.wav');


[bass,kick]=zeroPad({bass,kick});

%%
fftbass=fftMean(bass);
fftkick=fftMean(kick);

%%
% P2b = abs(fftbass);
% P1b = P2b(1:1024/2+1,2);
% P1b(2:end-1) = 2*P1b(2:end-1);
% f = bfs*(0:(1024/2))/1024;
% 
% P2k = abs(fftkick);
% P1k = P2k(1:1024/2+1,2);
% P1k(2:end-1) = 2*P1k(2:end-1);


subplot(2,1,1)
plotFFT(fftbass) 
title('Tom fft')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(2,1,2)
plotFFT(fftkick) 
title('Kick fft')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%
maskKB=calcMask(fftMean(kick),fftMean(bass),10);

numMaskFreq=length(find(maskKB));
f=44100*(0:(1024/2))/1024;
figure;
plot(f,maskKB>0,'r');
hold on
plotFFT(fftMean(kick));
plotFFT(fftMean(bass));
legend('Masking Frequencies','bass','kick')

