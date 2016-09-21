function p = initParticles_agg(N_part)
% Initialize Particles for agg PF given height and width of world

    numShark_part = randi([10 100], [N_part 1]); % between 10 and 100
    L_part = randi([30,80], [N_part 1]);
    p = [numShark_part, L_part];
    

end