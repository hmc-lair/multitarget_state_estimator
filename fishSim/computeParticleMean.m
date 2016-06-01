function p_mean = computeParticleMean(p, w)

    m_x1 = 0; m_y1 = 0; m_x2 = 0; m_y2 = 0;
    
    N_p = size(p,1);
    
    w_tot = sum(w)
    for i = 1:N_p
        m_x1 = m_x1 + p(i,1)* w(i);
        m_y1 = m_y1 + p(i,2)* w(i);
        m_x2 = m_x2 + p(i,3)* w(i);
        m_y2 = m_y2 + p(i,4)* w(i);
    end
    
    p_mean = [m_x1/w_tot, m_y1/w_tot, m_x2/w_tot, m_y2/w_tot];
        