function prob = getProbFromError_agg(p_agg, x_sharks, y_sharks, cum_ydist, cum_xdist,...
    point_sd_fit, point_mu_fit, numshark_sd, est_start, est_end)
% Get error measurement and corresponding probability from Gaussian
% Cum_dist: Cumulative distance of shark away from estimated line
    
    load d90x90fit_additional.mat
    numshark = p_agg(1);
    L = p_agg(2);
    
    % Line Fit Correction
    line_yerror = zeros(size(x_sharks, 2), 1);
    for s=1:size(x_sharks, 2)
        line_yerror(s) = dist_to_line(x_sharks(s), y_sharks(s), est_start, est_end);
    end
   

    % Get Phi, 90% Distance along line from center
    x90_sd = 2;
    bin_size_x = 1;
    [x90_current, line_yerror,~] = measureEdgeDistance(x_sharks,y_sharks,est_start,est_end);
    x90_actual = prctile([cum_xdist(:);x90_current],95);
    x90_actual_bin = round(x90_actual/bin_size_x)*bin_size_x;
    model_x90 = x90_fit(numshark,L);
    prob_x90 = normpdf(x90_actual_bin, model_x90, x90_sd);
    
    
    % Number of Shark Correction
    d90_sd = 1;
    bin_size_y = 0.5;
    d90_actual = prctile([cum_ydist(:);line_yerror], 90); % Use cumulative distance
    d90_actual_bin = round(d90_actual/bin_size_y) * bin_size_y; % Put into bin that matches model
    model_d90 = d90_fit(numshark, L);
    prob_d90 = normpdf(d90_actual_bin, model_d90, d90_sd);
    
    
    
    prob = prob_d90 * prob_x90;
    
end
