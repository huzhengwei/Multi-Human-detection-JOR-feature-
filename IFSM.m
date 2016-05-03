function [ g_index ] = IFSM( Sam_subset_index, gr_index, G_index_space, granule_value, labels, distr)
%IFSM Summary of this function goes here
%   Detailed explanation goes here

% granule_value = granule(S, grl_spac); %  whole granule_value space were
% generated

% G_index һά
% G_value = granule_value(G_index, :);
% G_index_space = nchoosek(G_index, 2);


Gr = G_index_space;
R_block = 2^(size(gr_index, 2) / 2 + 1);


for r = 1:length(Sam_subset_index)
    g_v_r = granule_value(:, Sam_subset_index{r});
    label_r = labels(Sam_subset_index{r});
    distr_r = distr(Sam_subset_index{r});
    Rr = response(gr_index,  g_v_r);
    Z = zeros(1, size(Gr, 1));
    for ind = 1:size(Gr, 1)
        R = Rr * 2 + response(Gr(ind, :), g_v_r );
%         R = [Rr; response(Gr(ind, :), g_v_r )];
        Z(ind) = norm_factor( R, label_r, distr_r, R_block);
    end
    beta = mean(Z);
    Gr = Gr(Z < beta, :);
end
Z = Z(Z < beta);
[~, min_ind] = min(Z);
g_index = Gr(min_ind, :);

end

