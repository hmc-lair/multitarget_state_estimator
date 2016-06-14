N_tri = 5;
ns_perf = zeros(N_tri, 1);

for tri = 1:N_tri
    run fishSim_7.m
    run att_pf.m
    ns_perf(tri) = within_ns_limit;
end
    