close all;
clear;
clc;

title_track1='tracks/12_Bass.wav';
[track1,fs1]=audioread(title_track1);
if size(track1,2)==2
track1=(track1(:,1)+track1(:,2))/sqrt(2);
end

title_track2='tracks/02_KickOut.wav';
[track2,fs2]=audioread(title_track2);
if size(track2,2)==2
track2=(track2(:,1)+track2(:,2))/sqrt(2);
end

%%
f_track1=fftOvMean(track1,0.5,1024,'hanning');
aux = f_track1.*conj(f_track1);
mag_fft1 = mag2db(smooth5(aux(1:1024/2+1)));
rnk1=rankFft(mag_fft1);

f_track2=fftOvMean(track2,0.5,1024,'hanning');
aux2 = f_track2.*conj(f_track2);
mag_fft2 = mag2db(smooth5(aux2(1:1024/2+1)));
rnk2=rankFft(mag_fft2);


%%
f = 44100*(0:(1024/2))/1024;
[mel,mr]=frq2mel(f);

subplot(2,1,1)
plot(mel,mag_fft1)
hold on
%plot(mel,(-rnk1),'g')
thr=10;
thr_line1=ones(size(mag_fft1))*mag_fft1(find(rnk1==thr));
plot(mel,thr_line1,'r')
title(title_track1)

subplot(2,1,2)
plot(mel,mag_fft2)
hold on
%plot(mel,(-rnk2),'g')
thr_line2=ones(size(mag_fft2))*mag_fft2(find(rnk2==thr));
plot(mel,thr_line2,'r')
title(title_track2)
hold off

%%
fac=0.5;

mask12=fac*calcMask(mag_fft1,mag_fft2,thr);

mask21=fac*calcMask(mag_fft2,mag_fft1,thr);

figure;

subplot(2,1,1)
plot(mel,-mask12);
hold on
plot(mel,mag_fft1)
% plot(mel,(-rnk1),'g')
% thr=15;
% thr_line1=ones(size(mag_fft1))*mag_fft1(find(rnk1==thr));
plot(mel,thr_line1,'r')
title(title_track1);

subplot(2,1,2)
plot(mel,-mask21);
hold on
plot(mel,mag_fft2)
% plot(mel,(-rnk2),'g')
% thr_line2=ones(size(mag_fft2))*mag_fft2(find(rnk2==thr));
plot(mel,thr_line2,'r')
title(title_track2)
hold off
title(title_track2);

%%
fr1 = (mask12>0).*(44100*(0+eps:(1024/2))/1024);
fr1=fr1(find(fr1));
G1=-mask12(find(mask12>0));
Q1=repmat(.7,[1,length(fr1)]);
type1=repCell('peak',length(fr1));

fr2 = (mask21>0).*(44100*(0+eps:(1024/2))/1024);
fr2=fr2(find(fr2));
G2=-mask21(find(mask21>0));
Q2=repmat(.7,[1,length(fr2)]);
type2=repCell('peak',length(fr2));

%%
if ~isempty(fr1)
    out_track1=cascade_filt(track1,fs1,type1,fr1,1,create_QPG(Q1,G1));
else
    out_track1=track1;
end
if ~isempty(fr2)
    out_track2=cascade_filt(track2,fs2,type2,fr2,1,create_QPG(Q2,G2));
else
    out_track2=track2;
end

%%
outfft=fftOvMean(out_track1,0.5,1024,'hanning');
aux = outfft.*conj(outfft);
mag_outfft1 = mag2db(smooth5(aux(1:1024/2+1)));
plot(mel,mag_outfft1)
figure
plot(mel,mag_fft1)


%%

mkdir('in')
mkdir('out')

audiowrite(strcat('in/in_',title_track1(8:end)),track1,44100);
audiowrite(strcat('out/out_',title_track1(8:end)),out_track1,44100);

audiowrite(strcat('in/in_',title_track2(8:end)),track2,44100);
audiowrite(strcat('out/out_',title_track2(8:end)),out_track2,44100);
