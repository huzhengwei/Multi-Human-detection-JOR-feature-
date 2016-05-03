function [ R ] = response( gr_index, granule_value )
%RESPONSE Summary of this function goes here
%   Detailed explanation goes here
R = zeros(1, size(granule_value,2));
% R = [];
for i = 2:2:size(gr_index, 2)
    R = R * 2 + (granule_value(gr_index(i-1), :) > granule_value(gr_index(i), :)); 
%     R = [ R; (granule_value(gr_index(i-1), :) > granule_value(gr_index(i), :)) ]; 
end

end

