function prob = getProbFromError(p, x_sharks, y_sharks, cum_ydist, cum_xdist,point_sd_fit, point_mu_fit, numshark_sd)
% Get error measurement and corresponding probability from Gaussian
% Cum_dist: Cumulative distance of shark away from estimated line
    load d90x90fit.mat
    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);
    numshark = p(5);
    L = p(6);
    
    % Line Fit Correction
    line_yerror = zeros(size(x_sharks, 2), 1);
    for s=1:size(x_sharks, 2)
        line_yerror(s) = point_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
    end
    
%     Add cost for segment length
    Z_line = sum(line_yerror);
    point_mu = 0;
    point_sd = 100;
    prob_line = normpdf(Z_line, point_mu, point_sd);
   

    % Get Phi, 90% Distance along line from center
    x90_sd = 2;
    bin_size_x = 1;
    [x90_current, ~,~] = measureEdgeDistance(x_sharks,y_sharks,[x1,y1],[x2,y2]);
    x90_actual = prctile([cum_xdist(:);x90_current],95);
    x90_actual_bin = floor(x90_actual/bin_size_x)*bin_size_x;
    model_x90 = x90_fit(numshark,L);
    prob_x90 = normpdf(x90_actual_bin, model_x90, x90_sd);
    
    
    % Number of Shark Correction
    d90_sd = 1;
    bin_size_y = 0.5;
    d90_actual = prctile([cum_ydist(:);line_yerror], 95); % Use cumulative distance
    d90_actual_bin = floor(d90_actual/bin_size_y) * bin_size_y; % Put into bin that matches model
    model_d90 = d90_fit(numshark, L);
    prob_d90 = normpdf(d90_actual_bin, model_d90, d90_sd);
    
    prob = prob_line * prob_d90 * prob_x90;
    
end
