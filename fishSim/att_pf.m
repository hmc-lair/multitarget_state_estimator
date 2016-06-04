clf
load fishSimData.mat

% PF Constants
Height = 50;
Width = 50;
N_part = 50;
Sigma_mean = 0.1;
x_sharks = x(1000:end, :); % Allow time for sharks to approach line
y_sharks = y(1000:end, :);
t_sharks = t(1000:end, :);
N_sharks = size(x_sharks,2);

numshark_sd = 0.4;
Show_visualization = false;

TS_PF = 1000;

% Initialize States
p = initParticles(Height, Width, N_part);
est_error = zeros(TS_PF,1);
act_error = zeros(TS_PF,1);
error = zeros(TS_PF,1);
numshark_est = zeros(TS_PF,1);
numshark_old = zeros(N_part, 2);

estimated = mean(p);


for i = 1:TS_PF
    disp(i)
    numshark_old(:,2) = numshark_old(:,1); % keep track of n-2
    numshark_old(:,1) = p(:,5);
    
    p = propagate(p, Sigma_mean, numshark_old(:,2));
    
    w = getParticleWeights(p, x_sharks(i,:), y_sharks(i,:), @fit_sumdist_sd, numshark_sd);
    p = resample(p,w);
    p_mean = computeParticleMean(p,w)
    
    est_error(i) = totalSharkDistance(x_sharks(i,:), y_sharks(i,:), [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)]);
    act_error(i) = totalSharkDistance(x_sharks(i,:), y_sharks(i,:), LINE_START, LINE_END);

    error(i) = pfError(x_sharks(i,:), y_sharks(i,:), LINE_START, LINE_END, [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)], N_sharks);
    numshark_est(i) = p_mean(5);
    % Visualize Sharks and Particles
    if Show_visualization
        arrowSize = 1.5;
        fig = figure(1);
        clf;
        hold on;
        % Plot Sharks
        for f=1:N_fish
           plot(x_sharks(i,f),y_sharks(i,f),'o'); 
           plot([x_sharks(i,f) x_sharks(i,f)+cos(t_sharks(i,f))*arrowSize],[y_sharks(i,f) y_sharks(i,f)+sin(t_sharks(i,f))*arrowSize]); 
        end

        % Plot Particles
        for g=1:N_part
            plot(p(g, 1), p(g,2), '.', 'MarkerSize', 10);
            plot(p(g, 3), p(g,4), '.', 'MarkerSize', 10);
        end

        % Plot Particle Mean Line
        plot([p_mean(1), p_mean(3)], [p_mean(2), p_mean(4)]);

        % Plot Attraction Line
        plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');

        pause(0.0001); 
    end
end

% Plot Performance of attraction line PF
subplot(3,1,1)
hold on
plot(act_error, '.')
plot(est_error, '.')
legend('Actual Line', 'Estimated Line')
title(sprintf('Comparison of Sum of Distance to Actual and Estimated Line for %d Sharks', N_fish));
hold off

subplot(3,1,2)
plot(error, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))')

subplot(3,1,3)
hold on
plot([0 TS_PF], [N_sharks N_sharks]);
plot(numshark_est, '.');
legend('Actual', 'Estimated')
title('Comparison of Actual and Estimated Number of Sharks')
ylim([0 110])
xlabel('Number of Steps')
hold off
% legend('Actual', 'Estimated')