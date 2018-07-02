function [ r ] = rankFft( x )
%rankFft Function that computes the rank vector for frequency region vector x
%   Input:
%       x: input frequency region vector
%   Output:
%       r: rank vector of x
%
    sorted=sort(x,'descend');
    r=zeros(size(x));

    for i=1:length(sorted)
        r(i)=find(sorted==x(i));
    end
    
end

