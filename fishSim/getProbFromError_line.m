function prob_line = getProbFromError_line(p, x_sharks, y_sharks)
% Get error measurement and corresponding probability from Gaussian
% Cum_dist: Cumulative distance of shark away from estimated line

    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);
    
    % Line Fit Correction
    line_yerror = zeros(size(x_sharks, 2), 1);
    for s=1:size(x_sharks, 2)
        line_yerror(s) = dist_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
    end
   
    Z_line = sum(line_yerror);
    point_mu = 0;
    point_sd = 10;
    prob_line = normpdf(Z_line, point_mu, point_sd);
  
    
end
