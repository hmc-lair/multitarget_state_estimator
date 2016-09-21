function w = getParticleWeights_agg(p, x_sharks, y_sharks, cum_ydist, cum_xdist, point_sd_fit, point_mu_fit, numshark_sd, est_start, est_end)
% Get Particle Weights using getProbFromError
% point_sd: Standard deviation to deterimine endpoint fit
% numshark_sd: Standard deviation to determine number of sharks
    N_part = size(p,1);
    w = zeros(N_part,1);
    
    parfor i=1:N_part
            point_sd_fit, point_mu_fit, numshark_sd, est_start, est_end);
    end
end
