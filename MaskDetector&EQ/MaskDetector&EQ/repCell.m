function [ cel ] = repCell( str,len )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cel=cell(1,len);
for i=1:len
    cel{i}=str;
end

end

