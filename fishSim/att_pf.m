
function [act_error, est_error, error, numshark_est] = att_pf(x, y, t, N_tagged, LINE_START, LINE_END, TS_PF, show_visualization)

% PF Constants
Height = 10;
Width = 10;
N_part = 100;
Sigma_mean = 0.5;
N_fish = size(x,2);
x_tagged = x(:, 1:N_tagged);
y_tagged = y(:, 1:N_tagged);
t_tagged = t(:, 1:N_tagged);

numshark_sd = 0.65;



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
    
    p = propagate(p, Sigma_mean, numshark_old(:,2), LINE_START, LINE_END);
    
    w = getParticleWeights(p, x_tagged(i,:), y_tagged(i,:), @fit_sumdist_sd, @fit_sumdist_mu, numshark_sd);
    p = resample(p,w);
    p_mean = computeParticleMean(p,w)
    
    
    est_error(i) = totalSharkDistance(x(i,:), y(i,:), [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)]);
    act_error(i) = totalSharkDistance(x(i,:), y(i,:), LINE_START, LINE_END);

    % Performance Error: Error between actual and estimated line
    error(i) = pfError(x(i,:), y(i,:), LINE_START, LINE_END, [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)], N_fish);
    numshark_est(i) = p_mean(5);

    % Visualize Sharks and Particles

    if show_visualization

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
        
        ylim([-10 10])
        xlim([-25 25])

        % Plot Attraction Line
        plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');

        pause(0.0001); 
    end
end



% Performance Criteria for numshark estimation
within_ns_limit = size(find( numshark_est > N_fish - 5 & numshark_est < N_fish + 5),1);

end
