clear;
clc;
%%

%%
d=dir(uigetdir);
for i=3:length(d)
    input{i-2}=strcat('tracks/',d(i).name);
end
%%
track=audioread(input{1});
f_track=fftOvMean(track,0.5,1024,'hanning');
aux = f_track.*conj(f_track);
mag_fft = mag2db(smooth5(aux(1:1024/2+1)));
f = 44100*(0:(1024/2))/1024;
[mel,mr]=frq2mel(f);
rnk1=rankFft(mag_fft);
%%
thr=50;
plot(mel,mag_fft)
hold on
thr_line1=ones(size(mag_fft))*mag_fft(find(rnk1==thr));
plot(mel,thr_line1,'r')
title('input track')

%%
param=analyze4EQ(thr,input);

%%

if ~isempty(param.f)
    out_track=cascade_filt(track,44100,param.type,param.f,1,param.GQ);
else
    out_track=track;
end
%%
mkdir('in')
mkdir('out')

audiowrite(strcat('in/in_',input{1}(8:end)),track,44100);
audiowrite(strcat('out/out_',input{1}(8:end)),out_track,44100);

%%

f_out_track=fftOvMean(out_track,0.5,1024,'hanning');
aux = f_out_track.*conj(f_out_track);
mag_out_fft = mag2db(smooth5(aux(1:1024/2+1)));
figure
plot(f,mag_fft)
figure
plot(f,mag_out_fft)

figure

