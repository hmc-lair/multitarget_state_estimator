function w = getParticleWeights(p, x_sharks, y_sharks, PF_sd, line_start, line_end)

    N_part = size(p,1);
    w = zeros(N,1);
    
    for i=1:N
        w(i) = getProbFromError(p(i,:), x_sharks, y_sharks, PF_sd, line_start, line_end)
    end
end
