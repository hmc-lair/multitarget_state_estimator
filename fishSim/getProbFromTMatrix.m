% Get equilibrium (normalized) Probability of states from Transition Matrix

function prob = getProbFromTMatrix(T,prob, ts)
    max_vert_dist = 7;
    increment = 0.05;
    x = -max_vert_dist:increment:max_vert_dist;
    for i = 1:ts
        prob = T * prob;
        
%         if ~mod(i,1000)
%             clf;
%             plot(x,prob,'.');
%             pause(0.0001); 
%             xlabel('Distance From Attraction Line')
%             ylabel('Probability')
%             disp(i)
%         end
    end
end


    