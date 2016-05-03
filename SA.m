function [ go_index, ratio ] = SA( g_index, Nb_index_space, T, granule_value, labels, distr)
%SA Summary of this function goes here
%   Detailed explanation goes here


N = 1000 * size(g_index, 2);
M = 0;
epsi = 0.01^( 1/N );
R = N;
% index   = randperm(size(Nb_index_space, 1));

Rsp = response(g_index,  granule_value);
Ea = norm_factor(  Rsp, labels, distr, 2^(size(g_index, 2) / 2 ) );
Eo = Ea;
go_index = g_index;
for r = 1:R
    ind = randi(size(Nb_index_space, 1));
    Rsp = response(Nb_index_space(ind, :),  granule_value);
    Eb = norm_factor(  Rsp, labels, distr, 2^(size(g_index, 2) / 2 ) );

    if (exp(-(Eb-Ea)/T) > rand(1)),
        g_index = Nb_index_space(ind, :);
        Ea = Eb;
        M = M + 1;
    end
    if (Eo < Ea),
        go_index = g_index;
        Eo = Ea;
    end
    T = T * epsi;
end
ratio = M / (N - M);
end



