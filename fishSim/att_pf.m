load fishSimData.mat

% PF Constants
Height = 50;
Width = 50;
N_part = 50;
Sigma_mean = 0.1;
x_sharks = x(1000:end, :); % Allow time for sharks to approach line
y_sharks = y(1000:end, :);
t_sharks = t(1000:end, :);

PF_sd = 10;
Show_visualization = true;

TS_PF = 500;

% Initialize States
p = initParticles(Height, Width, N_part);
error = zeros(TS_PF,1);
estimated = mean(p);


for i = 1:TS_PF
    disp(i)
    p = propagate(p, Sigma_mean);
    w = getParticleWeights(p, x_sharks(i,:), y_sharks(i,:), PF_sd);
    p = resample(p,w);
    p_mean = computeParticleMean(p,w);
    
    error(i) = totalSharkDistance(x_sharks(i,:), y_sharks(i,:), [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)]);
    
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

plot(error)