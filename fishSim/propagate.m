function p = propagate(p, sigma_mean)
%% Propagates particles by one move
    
    for indi_p = 1:size(p,1)
        x1 = p(indi_p, 1) + normrnd(0, sigma_mean);
        y1 = p(indi_p, 2) + normrnd(0, sigma_mean);
        x2 = p(indi_p, 3) + normrnd(0, sigma_mean);
        y2 = p(indi_p, 4) + normrnd(0, sigma_mean);  
        num_shark = p(indi_p, 5) + randi([-5 5]); % TODO: currently using uniform
        if num_shark < 10
            num_shark = randi([10, 100]);
        end
        
        p(indi_p, :) = [x1, y1, x2, y2, num_shark];
        
    end
end
