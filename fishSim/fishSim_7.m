%fishSim.m
% clear


% Declare Vars
N_fish=50;
N_attractors = 1;
N_tags = 50;
attractors = [0 0];
maxTime = 5000;
v=1.0;
deltaT = 0.1;
fishInteractionRadius = 1.5;
attractionRadius = 0;%15;
% fishInteractionRadiusSquared = fishInteractionRadius^2;
K_con = 0.1;
K_rep = 1e8;
K_att = 1;
K_rand = 0.1;

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
        x_att=0;y_att=0;
        for a = 1:N_attractors
            dist = sqrt((x(time-1,f)-attractors(a,1))^2 + (y(time-1,f)-attractors(a,2))^2);
            if dist > attractionRadius
                mag = (attractors(1,1)-x(time-1,f))^2 + (attractors(1,2)-y(time-1,f))^2 - dist;
                x_att = x_att + mag*(attractors(1,1)-x(time-1,f));
                y_att = y_att + mag*(attractors(1,2)-y(time-1,f));
            end
        end
        
        % Determine attraction to habitat
        sigmaRand = 0;
        %randTheta = sigmaRand*randn(1) + t(time-1,f);
        %x_rand = cos(randTheta);
        %y_rand = sin(randTheta);
        
        
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
    
    
%     loop over fish to plot
%     arrowSize = 1.5;
%     fig = figure(1);
%     clf;
%     hold on;
%     for f=1:N_fish
%        plot(x(time,f),y(time,f),'o'); 
%        plot([x(time,f) x(time,f)+cos(t(time,f))*arrowSize],[y(time,f) y(time,f)+sin(t(time,f))*arrowSize]);         
%     end
%     scale = 0.5;
%     axis(scale*[-width width -width width]);
%   
%     pause(0.0001); 
end


% Store the data
x = x';
y = y';
t = t';

% x_tag = x(:, 1:N_tags);
% y_tag = y(:, 1:N_tags);
% x_mean = mean(x_tag,2);
% y_mean = mean(y_tag,2);
save fishSimData.mat 
%x y t closeToNeighbor N_fish N_attractors v attractors maxTime K_con K_rep K_att K_rand sigmaRand 





