% Simulate shark trajectories using an attraction line model

function [x,y, t] = fishSim_7(N_fish, seg_length)

maxTime = 3000;
v=0.3;
deltaT = 1/30;
fishInteractionRadius = 1.5;
K_con = 0.05;
K_rep = 5e6;
K_att = 1e3;
K_rand = 0.1;
sigmaRand = 0.1;

% LINE_START = [-25 5.533]; % Actual Line
% LINE_END = [25 -5.3070];

% Same as actual line length

LINE_START = [-seg_length/2 0];
LINE_END = [seg_length/2 0];
% LINE_START = [-25.58 0];
% LINE_END = [25.58 0];


% Initialize states
% seg_length = 50;
t=zeros(maxTime,N_fish);
x=t;
y=t;
t(1,1:N_fish) = -ones(N_fish,1)*pi+rand([N_fish,1])*2*pi;
x(1,1:N_fish) = -ones(N_fish,1)*seg_length/2+rand([N_fish,1])*seg_length;
y(1,1:N_fish) = -ones(N_fish,1)*seg_length/2+rand([N_fish,1])*seg_length;
closeToNeighbor = zeros(maxTime,N_fish);


tic
%loop over time
for time=2:maxTime;

       
    %loop over fish to update state
    for f=1:N_fish

        % Check for neighbors
        x_rep = 0; y_rep = 0;closeToNeighbor(time,f) = 0;
        for g=1:N_fish
            dist = sqrt((x(time-1,f)-x(time,g))^2 + (y(time-1,f)-y(time-1,g))^2);
            if dist < fishInteractionRadius && g ~= f
                mag = (1/dist - 1/fishInteractionRadius)^2;
                x_rep = x_rep+mag*(x(time-1,f)-x(time-1,g));
                y_rep = y_rep+mag*(y(time-1,f)-y(time-1,g));     
                closeToNeighbor(time,f) = closeToNeighbor(time,f)+1;
            end
        end
        
        % Determine attraction to habitat
        closest_pt = project_point_to_line_segment(LINE_START, LINE_END, [x(time-1,f), y(time-1,f)]);
        dist = sqrt((x(time-1,f)-closest_pt(1))^2 + (y(time-1,f)-closest_pt(1))^2);
        mag = (closest_pt(1) -x(time-1,f))^2 + (closest_pt(2)-y(time-1,f))^2;
        x_att = mag*(closest_pt(1)-x(time-1,f));
        y_att = mag*(closest_pt(2)-y(time-1,f));
   
        % Sum all potentials
        x_tot = K_att*x_att + K_rep*x_rep;
        y_tot = K_att*y_att + K_rep*y_rep;
        desiredTheta = atan2(y_tot, x_tot);
        
        % Set yaw control
        maxControl = pi/180*20;
        controlTheta = K_con*angleDiff(desiredTheta-t(time-1,f)) + sigmaRand*randn(1);
        controlTheta = min(max(controlTheta,-maxControl), maxControl);
        
        % Update the state
        t(time,f) = t(time-1,f) + controlTheta;
        x(time,f) = x(time-1,f)+v*deltaT*cos(t(time,f));
        y(time,f) = y(time-1,f)+v*deltaT*sin(t(time,f));
        
        
        
    end
    
end
toc

t = t(1001:end, :);
x = x(1001:end, :);
y = y(1001:end, :);

% % Store the data
% save fishSimData.mat ...
%     t x y N_fish LINE_START LINE_END

end




