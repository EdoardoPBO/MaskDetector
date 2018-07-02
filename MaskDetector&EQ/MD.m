function [ maskVec ] = MD(thr,tracks)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
close all
numTracks=length(tracks);
for i=1:numTracks
    
    tracks{i}=audioread(tracks{i});
    
    if size(tracks{i},2)~=1
        
        tracks{i}=(tracks{i}(:,1)+tracks{i}(:,2))/sqrt(2);
        
    end
  
        
    fftTracks{i}=Mag(fftOvMean(tracks{i},0.5,1024,'hanning'));
    
    i
   
end

maskVec=detMask(fftTracks,thr);





end

