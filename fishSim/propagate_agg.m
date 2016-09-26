function p = propagate_agg(p)
%% Propagates particles by one move
    sigma = 0;

    for indi_p = 1:size(p,1)
        
        num_shark = p(indi_p, 1) + normrnd(0,5); 
        
%         if num_shark < 30 || num_shark > 70
%             num_shark = 30;
%         end
%         
%         L = p(indi_p, 2) + normrnd(0,2.5); 
%         if L < 15 || L > 35
%             L = 15;
%         end

        if num_shark < 10 
            num_shark = 10;
        end
        
        if num_shark > 150
            num_shark = 150;
        end
        
        L = p(indi_p, 2) + normrnd(0,2.5); 
        if L < 10
            L = 10;
        end
        
        if L > 50
            L = 50;
        end
        
        p(indi_p, :) = [num_shark,L];
        
    end
end
