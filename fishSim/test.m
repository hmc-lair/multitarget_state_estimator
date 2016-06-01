perf = zeros(size(act_error));
for i=size(act_error, 1)
    perf(i) = act_error(i)^2 - error(i)