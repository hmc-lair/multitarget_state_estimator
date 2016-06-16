function robots = initRobots(seg_length, N_robots)

robots(1:N_robots, 3)= -ones(N_robots,1)*pi+rand([N_robots,1])*2*pi;
robots(1:N_robots, 1)= -ones(N_robots,1)*seg_length/2+rand([N_robots,1])*seg_length;
robots(1:N_robots, 2) = 0;
end