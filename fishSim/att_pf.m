
function [act_error, est_error, error, numshark_est, x_robots, y_robots, num_tag_covered, seg_len, x90_act_list, d90_act_list, seg_len_dist] ...
    = att_pf(x, y, N_tagged, LINE_START, LINE_END, TS_PF, show_visualization, known_line)
% Top level particle filter for aggregation
% Two-step PF to (1) estimate line orientation, (2) estimate n and L.

% PF Constants
Height = 10;
Width = 30;
N_part = 50;
N_part_line = 50;
Sigma_mean = 1;
N_fish = size(x,2);

N_robots = 5;
range = 50;

numshark_sd = 0.65;

randomSharks = randperm(N_fish, N_tagged);
x_tagged = x(:, randomSharks);
y_tagged = y(:, randomSharks);



% Initialize States
robots = initRobots(50,N_robots);
p_agg = initParticles(Height, Width, N_part); % Initialize Particles
p_line = initParticles_Line(Height, Width, N_part_line);

est_error = zeros(TS_PF,1);
act_error = zeros(TS_PF,1);
error = zeros(TS_PF,1);
num_tag_covered = zeros(TS_PF,1);
numshark_est = zeros(TS_PF,1);
numshark_old = zeros(N_part, 2);
seg_len = zeros(TS_PF,1);
seg_len_dist = zeros(TS_PF,1);
x90_act_list = zeros(TS_PF,1);
d90_act_list = zeros(TS_PF,1);
shark_ydist_cum_list = zeros(TS_PF,N_fish); % keeps track of all y shark distance
shark_xdist_cum_list = zeros(TS_PF,N_fish); % keeps track of all x shark distance
x_robots = zeros(N_robots, TS_PF);
y_robots = zeros(N_robots, TS_PF);

% estimated = mean(p_agg);


for i = 1:TS_PF
    % Find tagged shark in range of robot. TODO: Everything is tagged now!!
    x_range = x_tagged(i,:);
    y_range = y_tagged(i,:);
    i_range = 1:N_fish;
    
    % Line PF
    p_line = propagate_line(p_line, Sigma_mean,known_line); 
    w_line = getParticleWeights_line(p_line, x_range, y_range);
    p_line = resample(p_line, w_line);
    p_mean_line = computeParticleMean(p_line, w_line)
    
%     % n, L PF
%     numshark_old(:,2) = numshark_old(:,1); % keep track of n-2
%     numshark_old(:,1) = p_agg(:,5);
%     
%     p_agg = propagate(p_agg, Sigma_mean, numshark_old(:,2), LINE_START, LINE_END,known_line);  
%     
%     w = getParticleWeights(p_agg, x_range, y_range, shark_ydist_cum_list(1:i-1,:), shark_xdist_cum_list(1:i-1,:), @fit_sumdist_sd, @fit_sumdist_mu, numshark_sd);
%     p_agg = resample(p_agg,w);
%     p_mean = computeParticleMean(p_agg,w)
%     
%     % Accumulate psi_90 and rho_90
%     [x90_current, ~,~] = measureEdgeDistance(x_range, y_range, [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)]);
%     shark_xdist_cum_list(i,:) = x90_current;
%     current_points_to_line = points_to_line(x_range, y_range, [p_mean(1), p_mean(2)], [p_mean(3), p_mean(4)]);
%     shark_ydist_cum_list(i,:) = ... % Update cumulative shark distance list
%         current_points_to_line;
%     
%     % Move Robot
%     robots = moveRobots(robots, x_range, y_range, ...
%         [p_mean(1) p_mean(2)], [p_mean(3) p_mean(4)]);
%     
%     x_robots(:,i) = robots(:,1);
%     y_robots(:,i) = robots(:,2);
%     
%     
%     est_error(i) = totalSharkDistance(x(i,:), y(i,:), LINE_START, LINE_END);
% %     act_error(i) = totalSharkDistance(x(i,:), y(i,:), LINE_START, LINE_END);
% 
%     % Performance Error: Error between actual and estimated line
    error(i) = pfError(x(i,:), y(i,:), LINE_START, LINE_END, [p_mean_line(1), p_mean_line(2)], [p_mean_line(3), p_mean_line(4)], N_fish);
%     numshark_est(i) = p_mean(5);
%     
%     % Segment Length
%     seg_len(i) = p_mean(6);
%     
%     % Estimated Segment Length based on distance
%     [~,~,seg_len_dist_i] = measureEdgeDistance(x(i,:),y(i,:),[p_mean(1),p_mean(2)],[p_mean(3),p_mean(4)]);
%     seg_len_dist(i) = seg_len_dist_i;
    
% %     % x90_estimated
% % %     line_error_est = zeros(size(x, 2), 1);
% % %     for s=1:size(x, 2)
% % %         line_error_est(s) = point_to_line(x(i,s), y(i,s), [p_mean(1),p_mean(2)], [p_mean(3),p_mean(4)]);
% % %     end
% %     bin_size_x = 1;
% %     x90_act = prctile(reshape(shark_xdist_cum_list(1:i-1,:),[],1),95);
% %     x90_actual_bin = floor(x90_act/bin_size_x)*bin_size_x
% %     x90_act_list(i) = x90_actual_bin;
%     
%     % d90_actual (with actual attraction line)
% %     line_error_act = zeros(size(x, 2), 1);
% %     for s=1:size(x, 2)
% %         line_error_act(s) = point_to_line(x(i,s), y(i,s), [LINE_START(1),LINE_START(2)], [LINE_END(1),LINE_END(2)]);
% %     end
%     bin_size_y = 0.5;
%     d90_act = prctile(reshape(shark_ydist_cum_list(1:i-1,:),[],1),95);
%     d90_actual_bin = floor(d90_act/bin_size_y)*bin_size_y
%     d90_act_list(i) = d90_actual_bin;

    % Visualize Sharks and Particles
        
    if show_visualization

        arrowSize = 1.5;
        fig = figure(1);
        clf;
        hold on;
        
        % Plot in range sharks
        for f = i_range
           plot(x(i,f),y(i,f),'x'); 
%            plot([x(i,f) x(i,f)+cos(t(i,f))*arrowSize],[y(i,f) y(i,f)+sin(t(i,f))*arrowSize]); 
        end
       
        
%         % Plot Tagged Sharks
%         for f=1:N_tagged
%            plot(x_tagged(i,f),y_tagged(i,f),'x'); 
%            plot([x_tagged(i,f) x_tagged(i,f)+cos(t_tagged(i,f))*arrowSize],[y_tagged(i,f) y_tagged(i,f)+sin(t_tagged(i,f))*arrowSize]); 
%         end
        
        
        % Plot Sharks
        for f = 1 : N_fish
           plot(x(i,f),y(i,f),'o'); 
%            plot([x(i,f) x(i,f)+cos(t(i,f))*arrowSize],[y(i,f) y(i,f)+sin(t(i,f))*arrowSize]); 
        end
        
        % Plot Robots
        for r = 1 : N_robots
            plot(robots(r,1),robots(r,2),'square',...
                'MarkerSize',20, 'MarkerFaceColor', [.49 1 .63]);
            plot([robots(r,1) robots(r,1)+cos(robots(r,3))*arrowSize],[robots(r,2) robots(r,2)+sin(robots(r,3))*arrowSize]); 
            circle(robots(r,1),robots(r,2), range);
            
        end

        % Plot Particles
        for h=1:N_part
            plot(p_line(h, 1), p_line(h,2), '.', 'MarkerSize', 10);
            plot(p_line(h, 3), p_line(h,4), '.', 'MarkerSize', 10);
        end

        % Plot Particle Mean Line
        plot([p_mean_line(1), p_mean_line(3)], [p_mean_line(2), p_mean_line(4)]);
 

        % Plot Attraction Line
        plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');

        ylim([-10 10])
        xlim([-25 25])
%         title(x90_act)
        pause(0.0001); 
    end
end



% Performance Criteria for numshark estimation
% within_ns_limit = size(find( numshark_est > N_fish - 5 & numshark_est < N_fish + 5),1);

end


function h = circle(x,y,r)
% Plot Circle given point and radius
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit);
end
