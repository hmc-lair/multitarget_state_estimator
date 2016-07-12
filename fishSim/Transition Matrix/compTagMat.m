function [diff_prob_tag] = compTagMat( x,y,increment,nTags )
% Compares T matrix with different number of tags over time
% Finds ss prob given by varying no. tags at different time and compare
% with ss prob from population matrix at that ts

ns = size(x,2);
nTrial = 3;
n_tag_len = length(nTags);
diff_prob = zeros(17, n_tag_len);

tic

for i = 1:n_tag_len
    nTag = nTags(i);

    diff_prob_tag = zeros(17, nTrial);

    for j = 1:5
        end_ts = j * 50; % at different ts
        
        for trial = 1:nTrial
            % Calculate T Matrix
            T_pop = transitionMatrix(x(1:end_ts,:),y(1:end_ts,:),increment);
            tag_ind = randperm(ns,nTag);
            T_tag = transitionMatrix(x(1:end_ts,tag_ind),y(1:end_ts,tag_ind),increment);

            % Calc ss probability
            nBins = length(T_pop);
            max_vert_dist = 10;
            p_int = 1/nBins * ones(1,nBins);
            p_fin_pop = getProbFromTMatrix(T_pop,p_int,100000,increment);
            p_fin_tag = getProbFromTMatrix(T_tag,p_int,100000,increment);

            diff_prob_tag(j,trial) = sum(abs(p_fin_pop - p_fin_tag)) % Diff in p from pop and tag matrix
        end
        
%         diff_prob_tag = mean(diff_prob_tag,1);

    end
    
    diff_prob(:,i) = mean(diff_prob_tag,2);
    
end
toc

plot(diff_prob,'x', 'MarkerSize', 20)
end


