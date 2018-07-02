function [ y ] = maskDetector( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
close all
varargin=varargin{1:end};
numTracks=length(varargin);
for i=1:numTracks
    
    tracks{i}=audioread(varargin{i}{1});
    
    if size(tracks{i},2)~=1
        
        tracks{i}=(tracks{i}(:,1)+tracks{i}(:,2))/2;
        
    end
        
    fftTracks{i}=fftMean(tracks{i});
    eval(sprintf('subplot(ceil(sqrt(numTracks)),ceil(sqrt(numTracks)),%d)',i));
    plotFFT(fftTracks{i});
    title(varargin{i});
   
end

y=detMask(fftTracks);
f=44100*(0:(1024/2))/1024;
figure;
    title('masking')
    
    for i=2:numTracks
            
        eval(sprintf('subplot(ceil(sqrt(numTracks-1)),ceil(sqrt(numTracks-1)),%d)',i-1));
        plotFFT(fftTracks{1});
        hold on
        plot(f,real(y(i-1,:)),'r')
        title(varargin{i});
        hold off
        
    end
    
    
    figure;
    title('ranking')
    for i=2:numTracks
        
        eval(sprintf('subplot(ceil(sqrt(numTracks-1)),ceil(sqrt(numTracks-1)),%d)',i-1));
        plotFFT(fftTracks{i});
        hold on
        plot(f,(-rankFft(fftTracks{i}(1:513))+513)/513,'g')
        title(varargin{i});
        hold off

end

