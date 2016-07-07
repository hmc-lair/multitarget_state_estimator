% Find Isolated Fish Groups to find gains

function clusters = findGroup(xRot, yRot)
% Associate with specific clusters with timesteps it belongs in
% (Continuous clusters)
    % Plot sharks and found cluster centers
    ts_act = 873;
    clusters = containers.Map;
    for i = 1:ts_act
        P = [xRot(i,:) ; yRot(i,:)];
        E = 0.25;
        minPts = 2;
        [C, ptsC, centres] = dbscan(P, E, minPts);

        clusters = findGroupPerStep(clusters,C,i);
        
        % Visualize
        clf
        hold on
        width = 30;
        scale = 0.5;
        axis(scale*[-width width -width width]);
        plot(P(1,:),P(2,:),'.')
        plot(centres(1,:),centres(2,:),'x')
        pause(0.0001)
        hold off
        disp(i)

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
    
  
        


