function [tDir] = getThetaDirection(x,y,x_t,y_t,theta,attraction)

    theta_t=atan2(y_t-y,x_t-x);
    if attraction == true
        tDir = -sign(angleDiff(theta_t-theta));
    else
        tDir = sign(angleDiff(theta_t-theta));
    end

