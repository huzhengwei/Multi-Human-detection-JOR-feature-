function [ samsub_index ] = sample_subset( sam_num, subset_num )
%SAMPLE_SUBSET Summary of this function goes here
%   Detailed explanation goes here
curr_setelem_num = sam_num;
for subset_ind = subset_num:-1:1
    index = randperm(sam_num);
    samsub_index{subset_ind} = index(1:curr_setelem_num);
    
    %% caculate the nearest even num
    curr_setelem_num = floor(curr_setelem_num/2);
    curr_setelem_num = curr_setelem_num + mod(curr_setelem_num, 2);
end

end

