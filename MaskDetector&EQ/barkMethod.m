function [out_track] = barkMethod( x1_in,x2_in,Q,rT,fs )
%barkMethod: Function that applies an equalization to x2_in to remove the
%frequency masking that such track is causing on track x1_in based on the bark Scale.
%   Input:
%       x1_in: reference track in samples
%       x2_in: input track
%       Q: Filter's Q factor
%       rT: rank Threshold, which defines whether or not a frequency is
%       considered essential
%       fs: sample frequency of the tracks (must be the same for both)
%   Output:
%       out_track: resulting track from the equalization of x2_in, in case
%       no masking is detected, out_track will be equal to x2_in
%
%% Stereo to Mono conversion (if necessary)
if size(x1_in,2)==2 
    x1=1/sqrt(2)*(x1_in(:,1)+x1_in(:,2));
else
    x1=x1_in;
end

if size(x2_in,2)==2
    x2=1/sqrt(2)*(x2_in(:,1)+x2_in(:,2));
else
    x2=x2_in;
end

%% extraction of frequency information for each track
X1=fftOvMean(x1,0.5,1024,'hanning');
X2=fftOvMean(x2,0.5,1024,'hanning');
%keep the real and positive part of the spectrum
X1=fftshift(X1);
X1=X1(length(X1)/2+1:end);
X2=fftshift(X2);
X2=X2(length(X2)/2+1:end);
%amplitude to dB conversion
X1=mag2db(abs(X1)); 
X2=mag2db(abs(X2));
%frequency and bark vectors
f = fs/2*linspace(0,1,length(X1));
[b,c]=frq2bark(f);

%% create frequency region vectors
barkvec=floor(b);
fz1=zeros(size(unique(barkvec)));
fz2=zeros(size(unique(barkvec)));

for i=0:max(barkvec)
    fz1(i+1)=max(X1(find(barkvec==i)));
    fz2(i+1)=max(X2(find(barkvec==i)));
end 

%% Masking Selection

maskVec=getFivePeak(calcMask(fz2,fz1,rT)); %calculate masking and keep the 5 frequency with more amplitude difference
G=-maskVec(find(maskVec~=0)); %gain vector
interpolMV=zeros(size(X2)); 
mag2find=fz2(find(maskVec~=0));
for i=1:length(mag2find)
    interpolMV(find(X2==mag2find(i)))=G(i);
    f2eq(i)=f(find(X2==mag2find(i))); %frequency vector
end
q=repmat(Q,[1,length(f2eq)]); %Q vector
GQ=create_QPG(q,G);
type=repCell('peak',length(f2eq)); %type vector

%% EQ
if isempty(G) %in the case that no masking has been found, return the input track
    out_track=x2_in;
else %cascade filtering
    out_track(:,1)=cascade_filt(x2_in(:,1),44100,type,f2eq,1,GQ);
    if size(out_track,2)==2
        out_track(:,2)=cascade_filt(x2_in(:,2),44100,type,f2eq,1,GQ);
    end
end

end

