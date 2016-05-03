function [ granule_value ] = granule( S, grl_spac )
%GRANULE Summary of this function goes here
%   Detailed explanation goes here
for sam_ind = 1:size(S,3)
    for grl_ind = 1:size(grl_spac,1)
        u = grl_spac(grl_ind, 2);
        v = grl_spac(grl_ind, 3);
        s = 2^grl_spac(grl_ind, 1);
        block = S(u:u+s-1, v:v+s-1, sam_ind);
       
        granule_value(grl_ind, sam_ind) = sum(block(:)) / (s^2);
    end
end
end




