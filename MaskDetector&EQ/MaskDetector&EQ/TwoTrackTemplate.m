%% charge tracks
title1='tracks/01_Vox1.wav';
title2='tracks/02_Vox2.wav';

[track1,fs1]=audioread(title1);
[track2,fs2]=audioread(title2);

track1=track1(:,1);
track2=track2(:,1);

%% fftMean
f_track1=fftMean(track1);
f_track2=fftMean(track2);

subplot(1,2,1)
plotFFT(f_track1);
title(title1);

subplot(1,2,2)
plotFFT(f_track2);
title(title2);

figure;

subplot(1,2,1)
plot(44100*(0:(1024/2)-1)/1024,513-rankFft(f_track1(1:512)))
title(title1);

subplot(1,2,2)
plot(44100*(0:(1024/2)-1)/1024,513-rankFft(f_track2(1:512)))
title(title2);

%% CALCULATE MASK

mask12=calcMask(f_track1(1:512),f_track2(1:512),10);
mask21=calcMask(f_track2(1:512),f_track1(1:512),10);

figure;

subplot(1,2,1)
plot(44100*(0:(1024/2)-1)/1024,mask12);
title(title1);

subplot(1,2,2)
plot(44100*(0:(1024/2)-1)/1024,mask21);
title(title2);

%% PREPARE EQ INPUT

fr1 = (mask12>0).*(44100*(0+eps:(1024/2-1))/1024);
fr1=fr1(find(fr1));
G1=20*log10(abs(mask12(find(mask12>0))));
Q1=repmat(5,[1,length(fr1)]);
type1=repCell('peak',length(fr1));

fr2 = (mask21>0).*(44100*(0+eps:(1024/2-1))/1024);
fr2=fr2(find(fr2));
G2=-20*log10(abs(mask21(find(mask21>0))));
Q2=repmat(5,[1,length(fr2)]);
type2=repCell('peak',length(fr2));

%% EQ

out_track1=cascade_filt(track1,type1,fr1,create_QPG(Q1,G1));
out_track2=cascade_filt(track2,type2,fr2,create_QPG(Q2,G2));

in1=abs(fft(track1));
in2=abs(fft(track2));

out1=abs(fft(out_track1));
out2=abs(fft(out_track2));

figure;
title(title1)
subplot(2,1,1)
plot((44100*(0+eps:(length(in1)/2-1))/length(in1)),in1(1:floor(length(in1)/2)))

subplot(2,1,2)
plot((44100*(0:(length(out1)/2-1))/length(out1)),out1(1:floor(length(out1)/2)))

figure;
title(title2)
subplot(2,1,1)
plot((44100*(0:(length(in2)/2-1))/length(in2)),in2(1:floor(length(in2)/2)))

subplot(2,1,2)
plot((44100*(0:(length(out2)/2-1))/length(out2)),out2(1:floor(length(out2)/2)))

figure;
subplot(2,1,1)
plot((44100*(0:(length(in2)/2-1))/length(in2)),in1(1:floor(length(in2)/2))-out1(1:floor(length(out1)/2)))
title(title1)

subplot(2,1,2)
plot((44100*(0:(length(out2)/2-1))/length(out2)),in2(1:floor(length(out2)/2))-out2(1:floor(length(out2)/2)))
title(title2)

%% generate new wavs

mkdir('in')
mkdir('out')

audiowrite(strcat('out/out_',title1(8:end)),track1,44100);
audiowrite(strcat('in/in_',title1(8:end)),out_track1,44100);

audiowrite(strcat('out/out_',title2(8:end)),track2,44100);
audiowrite(strcat('in/in_',title2(8:end)),out_track2,44100);




