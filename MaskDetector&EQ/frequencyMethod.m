function [output] = frequencyMethod( x1_in,x2_in,Q,rT,fs )
%FrequencyMethod: Function that applies an equalization to x2_in to remove the
%frequency masking that such track is causing on track x1_in.
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
% keep the real and positive part of the spectrum
X1=fftshift(X1);
X1=X1(length(X1)/2+1:end);
X2=fftshift(X2);
X2=X2(length(X2)/2+1:end);
%amplitude to dB conversion
X2=mag2db(abs(X2));
X1=mag2db(abs(X1));
%frequency and bark vectors
f = fs/2*linspace(0,1,length(X1));
[b,c]=frq2bark(f);
%% create frequency region vectors

fz1=X1;
fz2=X2;

%% Masking Selection
maskVec=getFivePeak(calcMask(fz2,fz1,rT));
G=-maskVec(find(maskVec~=0));
f2eq=f(find(maskVec~=0));

%% EQ
output=x2_in;
for i=1:size(x2_in,2)
    for j=1:length(f2eq)

        output(:,i)=peak(output(:,i), f2eq(j), Q, G(j));
        
    end
end

end