% Simulate shark trajectories using an attraction line model


% clear
% Declare Vars
N_fish= 100;
% N_tags = 10;
maxTime = 5000;
v=1.0;
deltaT = 0.1;
fishInteractionRadius = 1.5;
K_con = 0.05;
K_rep = 1e5;
K_att = 1e3;
K_rand = 0.1;
sigmaRand = 0.1;

LINE_START = [-10, 0];
LINE_END = [10,20];


% Initialize states
width = 50;
t=zeros(maxTime,N_fish);
x=t;
y=t;
t(1,1:N_fish) = -ones(N_fish,1)*pi+rand([N_fish,1])*2*pi;
x(1,1:N_fish) = -ones(N_fish,1)*width/2+rand([N_fish,1])*width;
y(1,1:N_fish) = -ones(N_fish,1)*width/2+rand([N_fish,1])*width;
closeToNeighbor = zeros(maxTime,N_fish);

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

t = t(1001:end, :);
x = x(1001:end, :);
y = y(1001:end, :);

% Store the data
save fishSimData.mat 




