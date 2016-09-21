function p_mean_agg = computeParticleMean_agg(p_agg, w)
% Compute mean particle based on weighting for agg PF.

    m_ns = 0; m_L = 0;
    
    N_p = size(p_agg,1);
    
    w_tot = sum(w);
    for i = 1:N_p
        m_ns = m_ns + p_agg(i,1)* w(i);
        m_L = m_L + p_agg(i,2)* w(i);
    end
    p_mean_agg = [m_ns/w_tot, m_L/w_tot];
end

        