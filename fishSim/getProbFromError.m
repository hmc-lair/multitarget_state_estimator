function prob = getProbFromError(p, x_sharks, y_sharks, PF_sd)
% Get error measurement and corresponding probability from Gaussian
    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);

    Z = totalSharkDistance(x_sharks, y_sharks, [x1 y1], [x2 y2]);
    prob = normpdf(Z, 0, PF_sd);
    
end
