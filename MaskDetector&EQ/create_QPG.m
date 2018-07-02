function [ QPG ] = create_QPG( q,pG )
%creat_QPG Creates cell of Q factor and Gain for EQ input
%   Input:
%       q: q factor vector
%       pG: Gain vector
%   Output:
%       QPG: output cell
    vec_aux=[q;pG]';
    QPG=[];

    for i=1:length(q)
        QPG{i}=vec_aux(i,:);
    end

end

