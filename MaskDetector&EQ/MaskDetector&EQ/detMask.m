function [ maskVec ] = detMask( tracks,thr )

    numTracks=length(tracks);
    numBins=length(tracks{1});
    maskVec=zeros(numTracks-1,numBins);
%     f = 44100*(0:(1024/2))/1024;

    
%     figure;
%     
%     
     for i=2:numTracks
%         
     
         maskVec(i-1,:)=calcMask(tracks{1}(1:numBins),tracks{i}(1:numBins),thr);
%         eval(sprintf('subplot(ceil(sqrt(numTracks-1)),ceil(sqrt(numTracks-1)),%d)',i-1));
%         plotFFT(tracks{1});
%         hold on
%         plot(f,maskVec(i-1,:),'r')
%         hold off
%         
     end
     
     

end

