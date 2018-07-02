function plotInputOutput(in,out)
%plotInputOutput Function that plots fft mean of signal in over the fft
%mean of signal out to check the work of the EQ
%   Input:
%       in: input track in time domain
%       out: output track in time domain
%   Output:
%       None
%
Xout=fftOvMean(out,0.5,1024,'hanning');
Xout=fftshift(Xout);
Xout=Xout(length(Xout)/2+1:end);
Xout=mag2db(abs(Xout));

Xin=fftOvMean(in,0.5,1024,'hanning');
Xin=fftshift(Xin);
Xin=Xin(length(Xin)/2+1:end);
Xin=mag2db(abs(Xin));

f = 44100/2*linspace(0,1,length(Xin));
[b,c]=frq2bark(f);

plot(f,Xout); hold on
plot(f,Xin,'r');
end

