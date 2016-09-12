function prob = getProbFromError(p, x_sharks, y_sharks, cum_dist, point_sd_fit, point_mu_fit, numshark_sd)
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
    line_error = zeros(size(x_sharks, 2), 1);
    for s=1:size(x_sharks, 2)
        line_error(s) = point_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
    end
    
%     Add cost for segment length
    Z_line = sum(line_error);
   
    point_mu = 0;
    point_sd = 100;
    
    prob_line = normpdf(Z_line, 0, point_sd);
    
%     % Seg_len based on edge sharks of line
%     seg_len_edge = measureEdgeDistance(x_sharks,y_sharks,[x1,y1],[x2,y2]);

    % Get Phi, 90% Distance along line from center
    x90_sd = 50;
    [x90_actual, ~,~] = measureEdgeDistance(x_sharks,y_sharks,[x1,y1],[x2,y2]);
    x90_actual_bin = floor(x90_actual/5)*5;
    model_x90 = x90_fit(numshark,L);
    prob_x90 = normpdf(x90_actual_bin, model_x90, x90_sd);
    
    
%     Number of Shark Correction
    d90_sd = 0.75;
    d90_actual = prctile([cum_dist(:);line_error], 90); % Use cumulative distance
    d90_actual_bin = floor(d90_actual); % Put into bin that matches model
    model_d90 = d90_fit(numshark, L);
    prob_d90 = normpdf(d90_actual_bin, model_d90, d90_sd);
    prob_d90 = 1;
    
    prob = prob_line * prob_d90 * prob_x90;
%     prob = prob_line;
    
end
