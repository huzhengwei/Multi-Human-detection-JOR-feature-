function [ grl_spac ] = granular_space( height, width )
%% caculate granular space
%   Detailed explanation goes here
% scale_vec = 0 : floor ( log2( min([height width]) ) );
scale_vec = 0 : 3;
height_max_vec = height + 1 - power(2, scale_vec);
width_max_vec = width + 1 - power(2, scale_vec);
grl_spac = [];
for s_ind = scale_vec
    for h_ind = 1: height_max_vec(s_ind+1);
        for w_ind = 1: width_max_vec(s_ind+1);
            grl_spac = [grl_spac; [s_ind, h_ind, w_ind]];
        end
    end
end
end

