function [ param ] = analyze4EQ( thr,tracks)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
factor=0.5;
masking=MD(thr,tracks);
mask=max(masking);
G=-0.5*mask(find(mask>0));
f=(mask>0).*(44100*(0+eps:(1024/2))/1024);
param.f=f(find(f));
q=repmat(0.9,[1,length(param.f)]);
param.GQ=create_QPG(q,G);
param.type=repCell('peak',length(param.f));

end

