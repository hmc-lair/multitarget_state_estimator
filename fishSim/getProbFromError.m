function prob = getProbFromError(p, x_sharks, y_sharks, point_sd_fit, point_mu_fit, numshark_sd)
% Get error measurement and corresponding probability from Gaussian
    load fit_max_area.mat
    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);
    numshark = p(5);
    seg_len = dist(x1, y1, x2, y2);
    
    cost_factor = 0.2;
    % Line Fit Correction
    line_error = zeros(size(x_sharks, 2), 1);
    for s=1:size(x_sharks, 2)
        line_error(s) = point_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
    end
    Z_line = sum(line_error);
    
    % FWeight for segment length
    cost = seg_len * cost_factor;
    Z_line = Z_line + cost;
    
    point_mu = point_mu_fit(numshark);
%     point_sd = point_sd_fit(numshark);
    point_sd = 100;
    
    prob_line = normpdf(Z_line, 0, point_sd);
    
    
    
    
    % Number of Shark Correction
    max_area_sd = 200;
    max_area = max(line_error) * seg_len;
    model_max_area = fit_max_area(seg_len, numshark);
    prob_ns = exp(- (max_area - model_max_area)^2/max_area_sd^2);
    
    prob = prob_line * prob_ns;
%     prob = prob_line;
    
end
