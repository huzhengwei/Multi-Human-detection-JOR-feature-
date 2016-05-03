function [ Z ] = norm_factor(  Data, Labels, distr, block_num )
%NORM_FACTOR Summary of this function goes here
%   Detailed explanation goes here

% nodes = train(WeakLrn, Data, Labels, distr);
% final_hyp= 0;
%   for i = 1:length(nodes)
%     curr_tr = nodes{i};
%     
%     step_out = calc_output(curr_tr, Data); 
%       
%     s1 = sum( (Labels ==  1) .* (step_out) .* distr);
%     s2 = sum( (Labels == -1) .* (step_out) .* distr);
% 
%     if(s1 == 0 && s2 == 0)
%         continue;
%     end
%     Alpha = 0.5*log((s1 + eps) / (s2+eps));
% 
% %     Weights(end+1) = Alpha;
%     
% %     Learners{end+1} = curr_tr;
%     
%     final_hyp = final_hyp + step_out .* Alpha;    
%   end
  
  block_truth = bsxfun(@eq, Data, (0:block_num-1)');
%   block_truth = bsxfun(@eq, sum( bsxfun(@times, Data, ...
%                                         2 .^ (0:size(Data, 1) - 1)'), 1) ...
%                             , (0:block_num-1)');
  s1 = sum( bsxfun(@times, block_truth, (Labels ==  1) .* distr), 2);
  s2 = sum( bsxfun(@times, block_truth, (Labels == -1) .* distr), 2);
  Z = 2 * sum((s1 .* s2) .* (1/2));
  
end

