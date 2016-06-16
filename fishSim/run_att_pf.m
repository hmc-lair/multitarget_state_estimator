% Initialize and run att_pf

% PF Constants
Height = 10;
Width = 10;
N_part = 500;
N_fish = size(x,2);
N_tagged = 50;
x_tagged = x(:, 1:N_tagged);
y_tagged = y(:, 1:N_tagged);
t_tagged = t(:, 1:N_tagged);
TS_PF = 100;
show_visualization = false;

LINE_START = [-25 0];
LINE_END = [25 0];


% Initialize States
p = initParticles(Height, Width, N_part);
est_error = zeros(TS_PF,1);
act_error = zeros(TS_PF,1);
error = zeros(TS_PF,1);
numshark_est = zeros(TS_PF,1);
numshark_old = zeros(N_part, 2);

for ts = 1:TS_PF
    [p, w, numshark_old] = att_pf(x_tagged, y_tagged, p, numshark_old);
    p_mean = computeParticleMean(p,w)
%     est_error(i) = totalSharkDistance(x(i,:), y(i,:), [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)]);
%     act_error(i) = totalSharkDistance(x(i,:), y(i,:), LINE_START, LINE_END);
% 
%     % Performance Error: Error between actual and estimated line
%     error(i) = pfError(x(i,:), y(i,:), LINE_START, LINE_END, [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)], N_fish);
%     numshark_est(i) = p_mean(5);

    % Visualize Sharks and Particles

    if show_visualization

        arrowSize = 1.5;
        fig = figure(1);
        clf;
        hold on;
        
        % Plot Tagged Sharks
        for f=1:N_tagged
           plot(x_tagged(ts,f),y_tagged(ts,f),'x'); 
           plot([x_tagged(ts,f) x_tagged(ts,f)+cos(t_tagged(ts,f))*arrowSize],[y_tagged(ts,f) y_tagged(ts,f)+sin(t_tagged(ts,f))*arrowSize]); 
        end
        
        
        % Plot Sharks
        for f = N_tagged+1 : N_fish
           plot(x(ts,f),y(ts,f),'o'); 
           plot([x(ts,f) x(ts,f)+cos(t(ts,f))*arrowSize],[y(ts,f) y(ts,f)+sin(t(ts,f))*arrowSize]); 
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