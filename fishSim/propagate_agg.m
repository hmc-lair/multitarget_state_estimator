function p = propagate_agg(p)
%% Propagates particles by one move
    sigma = 0;

    for indi_p = 1:size(p,1)
        
        num_shark = p(indi_p, 1) + normrnd(0,5); % TODO: currently using uniform
        
        if num_shark < 0 || num_shark > 150 
            num_shark = 1;
        end
        
        L = p(indi_p, 2) + normrnd(0, 5); 
        if L < 0 || L > 50
            L = 0;
        end
        
        p(indi_p, :) = [num_shark,L];
        
    end
end
