function [new_mv]=getFivePeak(mv)
    if length(mv~=0)<5
        new_mv=mv;
    else
        x=sort(mv,'descend');
        mv(find(mv<x(5)))=0;
        new_mv=mv;
    end
end