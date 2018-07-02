function [ maskAB ] = calcMask( xA,xB,rT )
%calcMask: Computes frequency masking detection of xA on xB based on rank
%threshold rT
%   Input:
%       xA: Masker bins
%       xB: Maskee bins
%       rT: rank threshold
%   Output:
%       maskAB: vector of gains for each bin
%
    %rank vectors for input
    rankA=rankFft(xA);
    rankB=rankFft(xB);
    %subtraction between frequency region vectors
    mask=(xA-xB);    
    mask(find(mask<0))=0; %negative values are set to 0

    for i=1:length(mask)
        if (rT>=rankA(i))||(rT<rankB(i)) %if frequency is essential for masker or not essential for maskee..
            mask(i)=0; %set to 0
        end
    end
    
    %output vector
    maskAB=mask;
    
end

