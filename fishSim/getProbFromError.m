function prob = getProbFromError(p, x_sharks, y_sharks, point_sd_fit, point_mu_fit, dens_sd)
% Get error measurement and corresponding probability from Gaussian
    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);
    dens = p(5);
    
    seg_length = dist(x1, y1, x2, y2);
    
    % Line Fit Correction
    line_error = zeros(size(x_sharks, 2), 1);
    for s=1:size(x_sharks, 2)
        line_error(s) = point_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
    end
    Z_line = sum(line_error)
    
%     point_mu = point_mu_fit(numshark);
%     point_sd = point_sd_fit(numshark);
%     
%     prob_line = normpdf(Z_line - point_mu, 0, point_sd);
    prob_line = normpdf(Z_line, 0, 50);
    
    % Number of Shark Correction
    max_d = max(line_error);
    model_maxd = fit_maxdist(seg_length, dens);
    prob_ns = exp(- (max_d - model_maxd)^2/dens_sd^2);
    
    prob = prob_line * prob_ns;
    
end
