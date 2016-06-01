function prob = getProbFromError(p, x_sharks, y_sharks, PF_sd)
% Get error measurement and corresponding probability from Gaussian
    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);

    Z = 0;
    for s=1:size(x_sharks, 2)
        error = point_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
        Z = Z + error;
    end
    prob = normpdf(Z, 0, PF_sd);
    
end
