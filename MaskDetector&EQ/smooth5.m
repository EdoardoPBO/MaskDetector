function [sm_x]=smooth5(x)
%smooth5: 5-point smoothening of spectrum x
%   Input:
%       x: magnitude spectrum
%   Output:
%       sm_x: smoothed spectrum
%
    sm_x=zeros(size(x));
    len=length(x);
    sm_x(1)=x(1);
    sm_x(end)=x(end);
    sm_x(2)=x(2);
    sm_x(end-1)=x(end-1);
    for i =3:len-2
        sm_x(i)=(x(i-2)+2*x(i-1)+3*x(i)+2*x(i+1)+x(i+2))/9;
    end
end