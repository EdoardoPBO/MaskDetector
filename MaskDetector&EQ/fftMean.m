function [ y ] = fftMean( x )

cont=0;
fftW=zeros(ceil(length(x)/1024),1024);
sec=1:1024:length(x);

for i=sec
    cont=cont+1;
    if i~=sec(end)
        fftW(cont,:)=fft(x(i:i+1023));
    else
        fftW(cont,:)=[fft(x(i:end));zeros(1024-length(fft(x(i:end))),1)];
    end
    if max(max(fftW(cont,:)))<20
        fftW(cont,:)=zeros(1024,1);
    end
end

fftW( ~any(fftW,2), : ) = [];

fftW=mean(fftW);

y=fftW(1:1024);



end

