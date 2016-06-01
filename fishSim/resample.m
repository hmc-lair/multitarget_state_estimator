function resampled = resample(p, w)
% Resample particles based on weight based on pseudocode from E160

    w_tot = sum(w);
    N = size(p, 1);
    
    for i = 1:N
        r = rand()*w_tot;
        j = 1;
        w_sum = w(1);
        
        while w_sum < r
            j = j+1;
            w_sum = w_sum + w(j);
        end
        
        resampled(i,:) = p(j, :);
    end
    
end
