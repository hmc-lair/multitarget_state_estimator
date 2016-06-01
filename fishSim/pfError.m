function error = pfError(x_sharks, y_sharks, act_start, act_end, est_start, est_end, N_sharks)
    
error_sum = 0;

for s=1:size(x_sharks, 2)
    is_above_act = isAbove(x_sharks(s), y_sharks(s), [act_start(1), act_start(2)], [act_end(1), act_end(2)]);
    act_dist = is_above_act * point_to_line(x_sharks(s), y_sharks(s), [act_start(1), act_start(2)], [act_end(1), act_end(2)]);
    
    is_above_est = isAbove(x_sharks(s), y_sharks(s), [est_start(1), est_start(2)], [est_end(1), est_end(2)]);
    est_dist = is_above_est * point_to_line(x_sharks(s), y_sharks(s), [est_start(1), est_start(2)], [est_end(1), est_end(2)]);

    error_sum = error_sum + (act_dist - est_dist)^2;
end


error = sqrt(error_sum/N_sharks)