function [ new_in ] = changeInput( input,i )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if i==1
        new_in=input;
    else
        aux=input{1};
        input{1}=input{i};
        input{i}=aux;
        new_in=input;
    end

end

