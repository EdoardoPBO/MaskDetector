%%
clear
close all
%% template for frequency method testing
[x1_in,fs]=audioread('tracks/09_Synth.wav');
x2_in=audioread('tracks/13_Piano.wav');
%%
x1=1/sqrt(2)*(x1_in(:,1)+x1_in(:,2));
x2=1/sqrt(2)*(x2_in(:,1)+x2_in(:,2));

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

subplot(2,1,1)
plot(b,X1)
axis([minx maxx miny maxy])
subplot(2,1,2)
plot(b,X2)
axis([minx maxx miny maxy])

%%
fz1=X1;
fz2=X2;

rank1=rankFft(fz1);
rank2=rankFft(fz2);
figure;
subplot(2,1,1)
plot(b,fz1); hold on
plot(b,fz2,'r');
axis([minx maxx miny maxy])
title('region vectors for piano (red) and synth (blue)')
xlabel('region')
ylabel('magnitude (dB)');
subplot(2,1,2)
plot(b,rank1); hold on
plot(b,rank2,'r');
axis([minx maxx 0 550])
title('rank vectors for piano (red) and synth (blue)')
xlabel('region')
ylabel('rank (u)');

%%
rT=20;
maskVec=getFivePeak(calcMask(fz2,fz1,rT));
G=-maskVec(find(maskVec~=0));
f2eq=f(find(maskVec~=0));


figure
plot(b,X2); hold on
title('detected masking: Filters to be applied (red)')
plot(b,-maskVec,'r');
xlabel('Frequency (barks)')
ylabel('Magnitude (dB)')

axis([minx maxx miny maxy])
%%
% q=repmat(1,[1,length(f2eq)]);
% GQ=create_QPG(q,G);
% type=repCell('peak',length(f2eq));
% out_track(:,1)=cascade_filt(x2_in(:,1),44100,type,f2eq,1,GQ);
% out_track(:,2)=cascade_filt(x2_in(:,2),44100,type,f2eq,1,GQ);
output=x2_in;
for i=1:size(x2_in,2)
    for j=1:length(f2eq)

        output(:,i)=peak(output(:,i), f2eq(j), 20, G(j));
        
    end
end
out=1/sqrt(2)*(output(:,1)+output(:,2));
Xout=fftOvMean(out,0.5,1024,'hanning');
Xout=fftshift(Xout);
Xout=Xout(length(Xout)/2+1:end);
Xout=mag2db(abs(Xout));
figure
plot(b,Xout); hold on
plot(b,-maskVec,'r');
plot(b,X2,'g');
axis([minx maxx miny maxy])
title('EQ output (green), EQ input (blue) and filters applied (red)')
xlabel('Frequency (barks)')
ylabel('Magnitude (dB)')

%%
audiowrite('tracks/output.wav',output,fs)
%%
aux=zeroPad({x1_in,x2_in});
x1_in=aux{1};
x2_in=aux{2};
L_in=integratedLoudness(x2_in+x1_in,fs);
L_out=integratedLoudness(output+x1_in,fs);
LD=['Loudness gain: ',num2str(L_out-L_in),' LUFS'];
disp(LD)
LD=['Loudness in: ',num2str(L_in),' LUFS'];
disp(LD)
LD=['Loudness out: ',num2str(L_out),' LUFS'];
disp(LD)
