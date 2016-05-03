function [ Nb_index_space ] = neighbors( g_index, nb1, nb2, grl_space, grl_space_d2 )
%NEIGHBOR Summary of this function goes here
%   Detailed explanation goes here


nb1_eq_index = bsxfun( @eq, (1:size(grl_space, 1))', g_index );

Nb_index_space = g_index;
for ind = 1:size(g_index, 2)   
    rsl2(:, ind) = sum(bsxfun( @minus, grl_space_d2, grl_space_d2(g_index(ind), :) ).^2, 2) .^ (1/2);
end
nb2_index = rsl2 <= nb2;

for nb = 1:nb1
   
    C = nchoosek(1:size(g_index, 2), nb);
    for i = 1:size(C, 1)
%         nb_index = nb1_eq_index;
        nb_index = ~nb1_eq_index(:, C(i, :)) & nb2_index(:, C(i, :));
        for j = 1:nb
            Elem{j} = find(nb_index(:, j))';
        end
%         sum = prod(sum(nb_index, 1));
        cbv = combvec(Elem{:})';
        tmp = repmat(g_index, size(cbv, 1), 1);
        tmp(:, C(i, :)) = cbv;
        Nb_index_space = [Nb_index_space; tmp];
    end
end


end

