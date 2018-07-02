function [sm_x]=smooth(x)
%smooth: 3-point smoothening of spectrum x
%   Input:
%       x: magnitude spectrum
%   Output:
%       sm_x: smoothed spectrum
%
    sm_x=zeros(size(x));
    len=length(x);
    sm_x(1)=x(1);
    sm_x(end)=x(end);
    for i =2:len-1
        sm_x(i)=(x(i-1)+x(i)+x(i+1))/3;
    end
end