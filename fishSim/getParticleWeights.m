function w = getParticleWeights(p, x_sharks, y_sharks, PF_sd)
% Get Particle Weights using getProbFromError
    N_part = size(p,1);
    w = zeros(N_part,1);
    
    for i=1:N_part
        w(i) = getProbFromError(p(i,:), x_sharks, y_sharks, PF_sd);
    end
end
