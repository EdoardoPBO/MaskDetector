function [ out ] = zeroPad( tracks )
%zeroPad: Function that adds zeros at the end of a cell of tracks so that
%they all have the same length
%   Input:
%       tracks: cell of tracks       
%   Output:
%       out: cell of tracks with the same size
numTracks=length(tracks);
A=zeros(1,numTracks);
out=cell(1,numTracks);

    for i=1:numTracks
        
        A(i)=length(tracks{i});
        
    end
    
    for i=1:numTracks
        
        out{i}=[tracks{i};zeros(max(A)-length(tracks{i}),size(tracks{i},2))];
        
    end
    
    
end

