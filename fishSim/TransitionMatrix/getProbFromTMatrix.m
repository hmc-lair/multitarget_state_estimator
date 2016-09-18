% Get equilibrium (normalized) Probability of states from Transition Matrix

function prob = getProbFromTMatrix(T,prob, ts, increment)
    max_vert_dist = 10;
    x = [-max_vert_dist:increment:-increment, ...
        increment:increment:max_vert_dist]';
    for i = 1:ts
        prob = prob * T;
        prob = prob/sum(prob); % Normalize Probabilities
        
%         if ~mod(i,10000) % Display Periodicaly
% %             clf;
% %             plot(x,prob,'.');
% %             pause(0.0001); 
% %             xlabel('Distance From Attraction Line')
% %             ylabel('Probability')
%             disp(i)
%         end
    end
end


    