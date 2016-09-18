function [diff_prob] = compTagMat( x,y,increment,nTags )
% Compares T matrix with different number of tags over time

% Finds ss prob given by varying no. tags at different time and compare
% with ss prob from population matrix at that ts

ns = size(x,2);
nTrial = 3;
n_tag_len = length(nTags);
len_ts = 10;
diff_prob = zeros(len_ts, n_tag_len);
ts_total = size(x,1);
end_ts_list = linspace(10,ts_total,len_ts);
% end_ts_list = ts_total;


% Calculate Population SS Prob
T_pop = transitionMatrix(x,y,increment);
nBins = length(T_pop);
max_vert_dist = 10;
p_int = 1/nBins * ones(1,nBins);
p_fin_pop = getProbFromTMatrix(T_pop,p_int,100000,increment);


% Compare performance for different no. of tags
parfor i = 1:n_tag_len
    nTag = nTags(i);
    diff_prob_tag = zeros(len_ts, nTrial);
    
    for j = 1:len_ts
        end_ts = round(end_ts_list(j)) % at different ts. Round to nearest integer
        
        for trial = 1:nTrial
            % Calculate T Matrix
            tag_ind = randperm(ns,nTag);
            T_tag = transitionMatrix(x(1:end_ts,tag_ind),y(1:end_ts,tag_ind),increment);

            % Calc ss probability
            p_fin_tag = getProbFromTMatrix(T_tag,p_int,100000,increment);
            
            % Diff in p from pop and tag matrix
            diff_prob_tag(j,trial) = sum(abs(p_fin_pop - p_fin_tag)) 
        end
    end
    
    diff_prob(:,i) = mean(diff_prob_tag,2); % Average between Trials
    
    disp(i)
    
end
toc

% plot(end_ts_list,diff_prob,'-x', 'MarkerSize', 12)
% legendStr = cellstr(num2str(nTags', '%-d Tags'))
% legend(legendStr)
% xlabel('Timestep (s)')
% ylabel('Diff between Population ss and Tagged ss')
% title('Difference between Equlibrium and Tagged ss at ts')

end


