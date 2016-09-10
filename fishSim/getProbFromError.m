function prob = getProbFromError(p, x_sharks, y_sharks, cum_dist, point_sd_fit, point_mu_fit, numshark_sd)
% Get error measurement and corresponding probability from Gaussian
% Cum_dist: Cumulative distance of shark away from estimated line
    load d90_fit.mat
    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);
    numshark = p(5);
    seg_len = dist(x1, y1, x2, y2);
    cost_factor = 0;
    seg_len = 50;
    
    % Line Fit Correction
    line_error = zeros(size(x_sharks, 2), 1);
    for s=1:size(x_sharks, 2)
        line_error(s) = point_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
    end
    
    % Add cost for segment length
    cost = seg_len * cost_factor;
    Z_line = sum(line_error) + cost;
    
%     point_mu = point_mu_fit(numshark);
    point_mu = 0;
%     point_sd = point_sd_fit(numshark);
    point_sd = 100;
    
    prob_line = normpdf(Z_line, 0, point_sd);
    
    % Seg_len based on edge sharks of line
    seg_len_edge = measureEdgeDistance(x_sharks,y_sharks,[x1,y1],[x2,y2]);
    
%     Number of Shark Correction
    d90_sd = 0.75;
    d90_actual = prctile([cum_dist(:);line_error], 90); % Use cumulative distance
    model_d90 = d90_fit(numshark, seg_len_edge);
%     prob_ns = exp(- (d90_actual - model_d90)^2/d90_sd^2);
    prob_ns = normpdf(d90_actual, model_d90, d90_sd);
    
    prob = prob_line * prob_ns;
%     prob = prob_line;
    
end
