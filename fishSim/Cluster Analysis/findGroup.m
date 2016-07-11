% Find Isolated Fish Groups to find gains

function clusters = findGroup(x_sharks, y_sharks, visualization)
% Associate with specific clusters with timesteps it belongs in
% (Continuous clusters)

    % Plot sharks and found cluster centers
    ts_act = 873;
    clusters = containers.Map;
    
    for i = 1:ts_act
%         s_ind = 
        P = [x_sharks(i,:) ; y_sharks(i,:)]; % Array of points
        E = 1; % Threshold Distance
        minPts = 2;
        maxPts = 3;
        [C, ptsC, centres] = dbscan(P, E, minPts, maxPts);
        clusters = findGroupPerStep(clusters,C,i);
        
        % Visualize
        if visualization
            clf
            hold on
            width = 30;
            height = 10;
            scale = 0.5;
            axis(scale*[-width width -height height]);
            plot(P(1,:),P(2,:),'.', 'MarkerSize',12)
            plot(centres(1,:),centres(2,:),'x', 'MarkerSize',12)
            title(i)
            pause(0.0001)
            hold off
        end
        

    end
end

function [clusters] = findGroupPerStep(clusters, C, ts)
% Associate specific clusters with the timestep which they exist in

    len_C = length(C);
    for i = 1:len_C
        % Check if already in dictionary
        ind_str = mat2str(C{i});
        if isKey(clusters, ind_str) % Append current timestep
            val = clusters(ind_str);
            clusters(ind_str) = [val,ts];

        else % Add to dictionary
            clusters(ind_str) = ts;
        end
    end
end
    
  
        


