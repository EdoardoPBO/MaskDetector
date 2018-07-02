%% template for Conception Engineering
title_track='tracks/01_PianoDI.wav';
[track,fs]=audioread(title_track);
track_mono=(track(:,1)+track(:,2))/sqrt(2);
%trackdiv=(track(:,1)+track(:,2))/2;

%% OVERLAP VS NO OVERLAP
close all
f_track=fftOvMean(track_mono,.5,1024,'rectangular');
plotFFT(f_track);
title('with overlap')

figure

f_track=fftMean(track_mono);
plotFFT(f_track);
title('without overlap')

%% WINDOW TYPE

close all

f_track=fftOvMean(track_mono,0.5,1024,'rectangular');
plotFFT(f_track);
title('rectangular')

figure

f_track=fftOvMean(track_mono,0.5,1024,'hanning');
plotFFT(f_track);
title('hanning')

%% OVERLAP 2.0

close all

subplot(3,2,2)
f_track=fftOvMean(track_mono,0.2,1024,'hanning');
plotFFT(f_track);
title('overlap=0.8');
%axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Amplitude')

subplot(3,2,3)
f_track=fftOvMean(track_mono,0.4,1024,'hanning');
plotFFT(f_track);
title('overlap=0.6');
%axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Amplitude')

subplot(3,2,4)
f_track=fftOvMean(track_mono,0.6,1024,'hanning');
plotFFT(f_track);
title('overlap=0.4');
%axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Amplitude')

subplot(3,2,5)
f_track=fftOvMean(track_mono,0.8,1024,'hanning');
plotFFT(f_track);
title('overlap=0.2');
%axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Amplitude')

subplot(3,2,6)
f_track=fftOvMean(track_mono,1,1024,'hanning');
plotFFT(f_track);
title('overlap=0');
%axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Amplitude')

subplot(3,2,1)
f_track=fftOvMean(track_mono,0.1,1024,'hanning');
plotFFT(f_track);
title('overlap=0.9');
%axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Amplitude')

%%

subplot(3,2,1)
f_track=fftOvMean(track_mono,0.5,128,'hanning');
new_plotFFT(f_track,128);
title('128')


subplot(3,2,2)
f_track=fftOvMean(track_mono,0.5,256,'hanning');
new_plotFFT(f_track,256);
title('256')


subplot(3,2,3)
f_track=fftOvMean(track_mono,0.5,512,'hanning');
new_plotFFT(f_track,512);
title('512')


subplot(3,2,4)
f_track=fftOvMean(track_mono,0.5,1024,'hanning');
new_plotFFT(f_track);
title('1024')


subplot(3,2,5)
f_track=fftOvMean(track_mono,0.5,2048,'hanning');
new_plotFFT(f_track,2048);
title('2048')

%%
%close all
figure

f_track=fftOvMean(track_mono,0.5,1024,'hanning');
new_plotFFT(f_track);
title('smoothen')

%%
close all

aux = f_track.*conj(f_track);
mag_fft = smooth5(aux(1:1024/2+1));
rnk=rankFft(mag_fft);
f = 44100*(0:(1024/2))/1024;
[mel,mr]=frq2mel(f);
plot(mel,smooth5(mag_fft))
hold on
plot(mel,(-rnk),'g')
thr=10;
thr_line=ones(size(mag_fft))*mag_fft(find(rnk==thr));
plot(mel,thr_line,'r')

%%




