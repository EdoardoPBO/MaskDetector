%% template for bark method testing
clear
close all
%%
[x1_in,fs]=audioread('tracks/09_Synth.wav');
x2_in=audioread('tracks/13_Piano.wav');
%%
x1=1/sqrt(2)*(x1_in(:,1)+x1_in(:,2));
x2=1/sqrt(2)*(x2_in(:,1)+x2_in(:,2));
%%
X1=fftOvMean(x1,0.5,1024,'hanning');
X2=fftOvMean(x2,0.5,1024,'hanning');
%%
X1=fftshift(X1);
X1=X1(length(X1)/2+1:end);
X1=mag2db(abs(X1));
X2=fftshift(X2);
X2=X2(length(X2)/2+1:end);
X2=mag2db(abs(X2));
f = fs/2*linspace(0,1,length(X1));
[b,c]=frq2bark(f);
%%
minx=0;
maxx=max(b);
miny=1.1*min([X1 X2]);
maxy=1.1*max([X1 X2]);

figure;
title('Resulting Spectrums extracted')
subplot(2,1,1)
plot(b,X1)
xlabel('Frequency (barks)')
ylabel('Magnitude (dB)')
title('Synth')
axis([minx maxx miny maxy])
subplot(2,1,2)
plot(b,X2)
xlabel('Frequency (barks)')
ylabel('Magnitude (dB)')
title('Piano')
axis([minx maxx miny maxy])
%%
barkvec=floor(b);
fz1=zeros(size(unique(barkvec)));
fz2=zeros(size(unique(barkvec)));

for i=0:max(barkvec)
    fz1(i+1)=max(X1(find(barkvec==i)));
    fz2(i+1)=max(X2(find(barkvec==i)));
end 
rank1=rankFft(fz1);
rank2=rankFft(fz2);
figure;
subplot(2,1,1)
plot(unique(barkvec),fz1); hold on
plot(unique(barkvec),fz2,'r');
title('region vectors for piano (red) and synth (blue)')
xlabel('region')
ylabel('magnitude (dB)');
subplot(2,1,2)
plot(unique(barkvec),rank1); hold on
plot(unique(barkvec),rank2,'r');
title('rank vectors for piano (red) and synth (blue)')
xlabel('region')
ylabel('rank (u)');
%%
figure;

rT=10;
maskVec=calcMask(fz2,fz1,rT);
G=-maskVec(find(maskVec~=0));
interpolMV=zeros(size(X2));
mag2find=fz2(find(maskVec~=0));
for i=1:length(mag2find)
    interpolMV(find(X2==mag2find(i)))=G(i);
    f2eq(i)=f(find(X2==mag2find(i)));
end


plot(b,X2); hold on
plot(b,interpolMV,'r');
axis([minx maxx miny maxy])
title('detected masking: Filters to be applied (red)')
xlabel('Frequency (barks)')
ylabel('Magnitude (dB)')


%%
q=repmat(5,[1,length(f2eq)]);
GQ=create_QPG(q,G);
type=repCell('peak',length(f2eq));
out_track(:,1)=cascade_filt(x2_in(:,1),44100,type,f2eq,1,GQ);
out_track(:,2)=cascade_filt(x2_in(:,2),44100,type,f2eq,1,GQ);

out=1/sqrt(2)*(out_track(:,1)+out_track(:,2));
Xout=fftOvMean(out,0.5,1024,'hanning');
Xout=fftshift(Xout);
Xout=Xout(length(Xout)/2+1:end);
Xout=mag2db(abs(Xout));
figure
plot(b,Xout); hold on
plot(b,interpolMV,'r');
plot(b,X2,'g');
title('EQ output (green), EQ input (blue) and filters applied (red)')
xlabel('Frequency (barks)')
ylabel('Magnitude (dB)')
axis([minx maxx miny maxy])
%%
audiowrite('tracks/output.wav',out_track,fs)
%%
aux=zeroPad({x1_in,x2_in});
x1_in=aux{1};
x2_in=aux{2};
L_in=integratedLoudness(x2_in+x1_in,fs);
L_out=integratedLoudness(out_track+x1_in,fs);
LD=['Loudness gain: ',num2str(L_out-L_in),' LUFS'];
disp(LD)
