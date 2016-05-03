clear
load ../readINRIA/train.mat
addpath 'GML_AdaBoost_Matlab_Toolbox_0.3'
addpath 'IFSM'
rand('state', 0)
% for i=1:100
%     S(:,:,i) = i*250*rand(10, 9);
% end
S = zeros(58, 24, size(pos, 3) + size(neg, 3));
S(:, :, 1:size(pos, 3)) = pos;
S(:, :, size(pos, 3) + 1 : end) = neg;
labels = [ones(1,size(pos, 3)), -1*ones(1,size(neg, 3))];
clear pos neg;


%% select compoenent
S = S(1:32, :, :);

%% test
load ../readINRIA/test.mat
testS = zeros(58, 24, size(pos, 3) + size(neg, 3));
testS(:, :, 1:size(pos, 3)) = pos;
testS(:, :, size(pos, 3) + 1 : end) = neg;
testlabels = [ones(1,size(pos, 3)), -1*ones(1,size(neg, 3))];
clear pos neg;
testS = testS(1:32, :, :);
test_fv = [];

%% S - the training image set
height = size(S, 1);
width = size(S, 2);
subset_num = 5; %% K
sam_num = size(S, 3);
distr = ones(1,sam_num);
distr = distr/(sum(distr));

Sam_subset_index = sample_subset(sam_num, subset_num);
grl_space = granular_space(height, width);
grl_space_d2 = zeros(size(grl_space));
grl_space_d2(:, 1) = pow2( grl_space(:, 1) - 1 );
grl_space_d2(:, 2:end) = grl_space(:, 2:end);

granule_value = granule(S, grl_space); %  whole granule_value space were generated
% labels = labels(1:40000);
%% test

testgranule_value = granule(testS, grl_space);
%%%%%%%%
T = 0.03;
ratio_target = 0.5;% 1.0 0.5 0.25
max_bit_len = 6;

G_index = 1:size(granule_value, 1);
G_index_space = nchoosek(G_index, 2);
for i = 1:size(G_index_space)
    R_g(:, i) = sum( (grl_space_d2(G_index_space(i, 1), :) - ...
                      grl_space_d2(G_index_space(i, 2), :) ) .^2 ) ...
                .^ (1/2);
end
G_index_space = G_index_space(R_g <= 4, :);

acc = 0;
feature_ind = 0;
fv_Rsp = [];
fv = [];
Learners = [];
Weights = [];
final_out = 0;
while acc < 0.99
    gr_index = [];
    feature_ind = feature_ind +1;
    while size(gr_index, 2) < 2 * max_bit_len
        g_tmp  = IFSM( Sam_subset_index, gr_index, G_index_space, granule_value, labels, distr);
        if isempty(g_tmp)
            break;
        end
        gr_index = [gr_index, g_tmp];
        Nb_index_space_SA = neighbors(gr_index, 1, 8, grl_space, grl_space_d2);
        [ gr_index, ratio ] = SA( gr_index, Nb_index_space_SA, T, granule_value, labels, distr);

        refine_G_index_space = neighbors(gr_index, 2, 4, grl_space, grl_space_d2);
        gr_index = IFSM( Sam_subset_index, [] , refine_G_index_space, granule_value, labels, distr);    
    end
    fv{end + 1} = gr_index;
    R = response(gr_index,  granule_value);
    fv_Rsp = [fv_Rsp;R];
    
    [ RLearners RWeights ] = RealAdaBoost(tree_node_w(16), fv_Rsp, labels, 160);
%     Learners{end + 1} = RLearners;
%     Weights{end + 1} = RWeights;
    ResultR = Classify(RLearners, RWeights, fv_Rsp);
%     final_out = final_out + ResultR;
    
    acc = sum (sign(ResultR) == labels) / length(labels)
    %% test
    testR = response(gr_index,  testgranule_value);
    test_fv = [test_fv;testR];
    testResultR = Classify(RLearners, RWeights, test_fv);
    
    testacc = sum (sign(testResultR) == testlabels) / length(testlabels)
    %%

    distr = exp(- 1 * (labels .* ResultR));
    Z = sum(distr);
    distr = distr / Z;  
    
    T = ratio_target * T / ratio;   
end
save model.mat fv fv_Rsp RLearners RWeights



