function [robots] = moveRobots(robots, x_range, y_range, att_line_start, att_line_end)
% Move robots according to fish movement model

% Movement constants
v=1.0;
deltaT = 0.1;
robotInteractionRadius = 1.5;
K_con = 0.05;
K_rep = 1e5;
K_att = 1e3;
K_rand = 0.1;
sigmaRand = 0.1;

N_robots = size(robots,1);
N_range = size(x_range,2);

x_robots = robots(:,1);
y_robots = robots(:,2);
t_robots = robots(:,3);

%loop over robot to update state
for f=1:N_robots

%     % Check for robots (Repulsive)
%     x_rep = 0; y_rep = 0;
%     for g=1:N_robots
%         dist = sqrt((x_robots(f)-x_robots(g))^2 + (y_robots(f)-y_robots(g))^2);
%         if dist < robotInteractionRadius
%             mag = (1/dist - 1/robotInteractionRadius)^2;
%             x_rep = x_rep+mag*(x_robots(f)-x_robots(g));
%             y_rep = y_rep+mag*(y_robots(f)-y_robots(g));     
%         end
%     end

%     Check for in-range fish
    x_rep = 0; y_rep = 0;
    for g=1:N_range
        dist = sqrt((x_robots(f)-x_range(g))^2 + (y_robots(f)-y_range(g))^2);
        if dist < robotInteractionRadius
            mag = (1/dist - 1/robotInteractionRadius)^2;
            x_rep = x_rep+mag*(x_robots(f)-x_range(g));
            y_rep = y_rep+mag*(y_robots(f)-y_range(g));     
        end
    end

    % Determine attraction to habitat
    closest_pt = project_point_to_line_segment(att_line_start, att_line_end, [x_robots(f), y_robots(f)]);
    dist = sqrt((x_robots(f)-closest_pt(1))^2 + (y_robots(f)-closest_pt(1))^2);
    mag = (closest_pt(1) -x_robots(f))^2 + (closest_pt(2)-y_robots(f))^2;
    x_att = mag*(closest_pt(1)-x_robots(f));
    y_att = mag*(closest_pt(2)-y_robots(f));

    % Sum all potentials
    x_tot = K_att*x_att + K_rep*x_rep;
    y_tot = K_att*y_att + K_rep*y_rep;
    desiredTheta = atan2(y_tot, x_tot);

    % Set yaw control
    maxControl = pi/180*20;
    controlTheta = K_con*angleDiff(desiredTheta-t_robots(f)) + sigmaRand*randn(1);
    controlTheta = min(max(controlTheta,-maxControl), maxControl);

    % Update the state
    robots(f,3) = robots(f,3) + controlTheta; % t
    robots(f,1) = robots(f,1) + v*deltaT*cos(robots(f,3)); % x
    robots(f,2) = robots(f,2) + v*deltaT*sin(robots(f,3)); % y


end

