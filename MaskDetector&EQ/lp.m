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
thr=60;
plot(mel,mag_fft)
hold on
thr_line1=ones(size(mag_fft))*mag_fft(find(rnk1==thr));
plot(mel,thr_line1,'r')
title('input track')
%%
factor=0.5;
fc=f(find(rnk1==ceil(thr*(1+factor))));
out_track=cascade_filt(track,44100,'low_pass',fc,1,.5);

%%
f_out=fftOvMean(out_track,0.5,1024,'hanning');
aux = f_out.*conj(f_out);
out_mag_fft = mag2db(smooth5(aux(1:1024/2+1)));
plot(f,db2mag(mag_fft))
figure
plot(f,db2mag(out_mag_fft))

%%
audiowrite('out/low_passedbass.wav',out_track,44100);