function p = propagate(p, sigma_mean, ns_t2, LINE_START, LINE_END)
%% Propagates particles by one move
    sigma = 0;

    for indi_p = 1:size(p,1)
        x1 = p(indi_p, 1) + normrnd(0, sigma_mean);
        y1 = p(indi_p, 2) + normrnd(0, sigma_mean);
        x2 = p(indi_p, 3) + normrnd(0, sigma_mean);
        y2 = p(indi_p, 4) + normrnd(0, sigma_mean);  
       
        num_shark = p(indi_p, 5) + sigma*(p(indi_p,5) - ns_t2(indi_p))...
            + normrnd(0,1); % TODO: currently using uniform
        
        if num_shark < 0
            num_shark = 1;
        end
        
        L = p(indi_p, 6) + normrnd(0, 5); 
        if L < 0 || L > 50
            L = 0;
        end
        
%         L = 50;
        p(indi_p, :) = [x1, y1, x2, y2, num_shark,L];
        
    end
end
