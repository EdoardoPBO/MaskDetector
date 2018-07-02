function [ output_args ] = plotFFT( x )




P2 = x.*conj(x);%
P1 = P2(1:1024/2+1);
%P1(2:end-1) = 2*P1(2:end-1);
f = 44100*(0:(1024/2))/1024;
[mel,mr]=frq2mel(f);
plot(mel,P1)


end

