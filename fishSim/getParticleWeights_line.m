function w = getParticleWeights_line(p, x_sharks, y_sharks)
% Get Particle Weights using getProbFromError
% point_sd: Standard deviation to deterimine endpoint fit
% numshark_sd: Standard deviation to determine number of sharks
    N_part = size(p,1);
    w = zeros(N_part,1);
    
    parfor i=1:N_part
        w(i) = getProbFromError_line(p(i,:), x_sharks, y_sharks);
    end
end
