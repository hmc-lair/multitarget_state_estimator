function error = att_pf(x, y, t, N_tagged, LINE_START, LINE_END)
% load fishSimData.mat

% PF Constants
Height = 10;
Width = 10;
N_part = 50;
Sigma_mean = 1;
% N_tagged = 112;
N_fish = size(x,2);
x_tagged = x(:, 1:N_tagged); % Allow time for sharks to approach line
y_tagged = y(:, 1:N_tagged);
t_tagged = t(:, 1:N_tagged);


PF_sd = 18;
Show_visualization = false;

TS_PF = 500;

% Initialize States
p = initParticles(Height, Width, N_part);
est_error = zeros(TS_PF,1);
act_error = zeros(TS_PF,1);
error = zeros(TS_PF,1);

estimated = mean(p);


for i = 1:TS_PF
%     disp(i)
    p = propagate(p, Sigma_mean);
    w = getParticleWeights(p, x_tagged(i,:), y_tagged(i,:), PF_sd);
    p = resample(p,w);
    p_mean = computeParticleMean(p,w);
    
    est_error(i) = totalSharkDistance(x(i,:), y(i,:), [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)]);
    act_error(i) = totalSharkDistance(x(i,:), y(i,:), LINE_START, LINE_END);

    % Performance Error: Error between actual and estimated line
    error(i) = pfError(x(i,:), y(i,:), LINE_START, LINE_END, [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)], N_fish);

    % Visualize Sharks and Particles
    if Show_visualization
        arrowSize = 1.5;
        fig = figure(1);
        clf;
        hold on;
        
        % Plot Tagged Sharks
        for f=1:N_tagged
           plot(x_tagged(i,f),y_tagged(i,f),'x'); 
           plot([x_tagged(i,f) x_tagged(i,f)+cos(t_tagged(i,f))*arrowSize],[y_tagged(i,f) y_tagged(i,f)+sin(t_tagged(i,f))*arrowSize]); 
        end
        
        
        % Plot Sharks
        for f = N_tagged+1 : N_fish
           plot(x(i,f),y(i,f),'o'); 
           plot([x(i,f) x(i,f)+cos(t(i,f))*arrowSize],[y(i,f) y(i,f)+sin(t(i,f))*arrowSize]); 
        end

        % Plot Particles
        for h=1:N_part
            plot(p(h, 1), p(h,2), '.', 'MarkerSize', 10);
            plot(p(h, 3), p(h,4), '.', 'MarkerSize', 10);
        end

        % Plot Particle Mean Line
        plot([p_mean(1), p_mean(3)], [p_mean(2), p_mean(4)]);

        % Plot Attraction Line
        plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');

        pause(0.0001); 
    end
end


% Plot Performance of attraction line PF
subplot(2,1,1)
hold on
plot(act_error, '.')
plot(est_error, '.')
legend('Actual Line', 'Estimated Line')
title(sprintf('Comparison of Sum of Distance to Actual and Estimated Line for %d tagged out of %d Sharks', N_tagged, N_fish));
hold off

subplot(2,1,2)
plot(error, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2)/numshark)')
end
