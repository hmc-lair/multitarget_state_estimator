function prob = getProbFromError(p, x_sharks, y_sharks, PF_sd, line_start, line_end)
% Get error measurement and corresponding probability from Gaussian

    x1 = p(1);
    y1 = p(2);
    x2 = p(3);
    y2 = p(4);
    
    prob = 1;

    error = 0;
    for s=1:size(x_sharks, 1)
        s = s + point_to_line(x_sharks(s), y_sharks(s), line_start, line_end)
    end
    
    prob = normpdf(s, 0, PF_sd)
    
end
