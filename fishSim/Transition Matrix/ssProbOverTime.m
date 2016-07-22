function [error] = ssProbOverTime(x,y, nTag_list)
% Graph steady state probability from T matrix constructed over time
increment = 1;
max_vert_dist = 10;
ts_total = size(x,1);
end_ts_len = 50;
end_ts_list = linspace(10,ts_total,end_ts_len);
hist_edges = -max_vert_dist:increment:max_vert_dist-increment;
ns = size(x,2);
nTag_len = length(nTag_list)
error = zeros(end_ts_len,nTag_len);


% Equilibrium (ss prob using all ts of population)
T = transitionMatrix(x,y,increment);
nBins = length(T);
p_int = 1/nBins * ones(1,nBins);
p_fin_pop = getProbFromTMatrix(T,p_int,100000,increment);


for i = 1:nTag_len
    nTag = nTag_list(i);
    tag_ind = randperm(ns,nTag);
    
    for j = 1:end_ts_len
        j
        % Get ss probs
        end_ts = round(end_ts_list(j));

        T_tag = transitionMatrix(x(1:end_ts,tag_ind),y(1:end_ts,tag_ind),increment);

        nBins = length(T_tag);
        p_int = 1/nBins * ones(1,nBins);
        p_fin = getProbFromTMatrix(T_tag,p_int,100000,increment);

        % Find error
        error(j,i) = sum(abs(p_fin_pop - p_fin)) ;
        % Plot
    %     clf
    %     hold on
    %     plot(hist_edges, p_fin, '-x')
    %     plot(hist_edges, p_fin_pop, '-x')
    %     xlabel('Distance from attraction line (m)')
    %     ylabel('Probability')
    %     title(sprintf('Timestep: %f, Error: %f',end_ts,error));
    %     hold off
    %     pause(0.00001)
    end
end
% Graph tagged shark traj
% figure
% title('Tagged Shark Trajectories')
% plot(x(:,tag_ind),y(:,tag_ind),'.');
% xlabel('x (m)')
% ylabel('y (m)')
figure 
title('Tagged SS prob error over time')
xlabel('Timestep')
ylabel('Error')
plot(error,'.')


end