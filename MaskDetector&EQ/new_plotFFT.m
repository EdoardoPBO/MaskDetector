function [ output_args ] = new_plotFFT( x,varargin )

if isempty(varargin)
    win=1024;
    
else
    win=varargin{1};
end
P2 = x.*conj(x);
P1 = P2(1:win/2+1);
f = 44100*(0:(win/2))/win;
[mel,mr]=frq2mel(f);
%plot(f,mag2db(smooth5(P1)))
plot(mel,mag2db((P1)))

end
