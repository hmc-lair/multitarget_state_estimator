function p = initParticles(height, width, N_part)
% Initialize Particles for att_pf.m given height and width of world
% x1, y1, x2, y2
 
    x1_part = rand(N_part, 1) * width - width/2;
    y1_part = rand(N_part, 1) * height - height/2;
    x2_part = rand(N_part, 1) * width - width/2;
    y2_part = rand(N_part, 1) * height - height/2;
    dens_part = randi([1 3], [N_part 1]);
    p = [x1_part, y1_part, x2_part, y2_part, dens_part];

end