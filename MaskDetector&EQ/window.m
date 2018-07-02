%% template for windowing study
title_track='tracks/01_PianoDI.wav';
[track,fs]=audioread(title_track);
track_mono=(track(:,1)+track(:,2))/sqrt(2);
track_mono=track_mono(50000:50000 + 2047);
subplot(2,2,1)
plot(track_mono);
xlabel('Time(Samples)')
ylabel('Amplitude')
title('Rectangular Window');
axis([0 1023 min(track_mono)-.02 max(track_mono)+.02]);
%%
w=hanning(1024);
w_track=track_mono.*w;
subplot(2,2,2)
plot(w_track);
xlabel('Time(Samples)')
ylabel('Amplitude')
title('Hanning Window');
axis([0 1023 min(track_mono)-.02 max(track_mono)+.02]);

%%
w_X=fft(w_track);
X=fft(track_mono);

subplot(2,2,4)
title('Hanning Window');
plotFFT(w_X)
axis([0 3923 -200 60])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')
subplot(2,2,3)
title('Rectangular Window');
plotFFT(X)
axis([0 3923 -200 60])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')
%%
figure();
ham=fft(hamming(1024).*track_mono);
bla=fft(blackman(1024).*track_mono);
blh=fft(blackmanharris(1024).*track_mono);

subplot(2,2,1)
plotFFT(w_X)
title('Hanning Window');
axis([0 3923 -200 60])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')

subplot(2,2,2)
plotFFT(ham)
title('Hamming Window');
axis([0 3923 -200 60])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')

subplot(2,2,3)
plotFFT(bla)
title('Blackman Window');
axis([0 3923 -200 60])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')

subplot(2,2,4)
plotFFT(blh)
title('Blackman-Harris Window');
axis([0 3923 -200 60])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')

%%
figure();
X256=fft(hamming(256).*track_mono(1:256));
X512=fft(hamming(512).*track_mono(1:256*2));
X1024=fft(hamming(1024).*track_mono(1:256*4));
X2048=fft(hamming(2048).*track_mono);

subplot(2,2,1)
new_plotFFT(X256,256)
title('size=256');
axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')

subplot(2,2,2)
new_plotFFT(X512,512)
title('size=512');
axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')

subplot(2,2,3)
new_plotFFT(X1024,1024)
title('size=1024');
axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')

subplot(2,2,4)
new_plotFFT(X2048,2048)
title('size=2048');
axis([0 3923 -200 70])
xlabel('Frequency(mels)')
ylabel('Magnitude(dB)')