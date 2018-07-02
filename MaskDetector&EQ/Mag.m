function [ mag ] = Mag( spec )
%Mag Summary of this function goes here
%   Detailed explanation goes here
len=length(spec);
aux = spec.*conj(spec);
mag = mag2db(smooth5(aux(1:len/2+1)));

end

