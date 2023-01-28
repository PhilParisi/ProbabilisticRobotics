function [state] = generate_weather(days)


% Initial state (random number between 1 and 3)
state(1:days) = [0];
state(1) = randi(3,1); % should this be uniform random?
%state(1) = 1;

% Loop to simulate a day
    % i = current day
    % i+1 = next day

for i = 1:(days-1)
    
    % random number between 0 and 1
    rng = rand(1,1);

    switch state(i)
        case 1  % it is sunny
            if rng >= 0.2
                next_state = 1; % will be sunny
            else 
                next_state = 2; % will be cloudy
            end
                
        case 2  % it is cloudy
            if rng >= 0.6
                next_state = 1; % will be sunny
            elseif (rng >= 0.2 && rng < 0.6)
                next_state = 2; % will be cloudy
            else
                next_state = 3; % will be rainy
            end

        case 3  % it is rainy
            if rng >= 0.8
                next_state = 1; % will be sunny
            elseif (rng >= 0.2 && rng < 0.8)
                next_state = 2; % will be cloudy
            else
                next_state = 3; % will be rainy
            end
            
        otherwise % should never be here
            disp('something is broken')
            break

    end
    
    % assign next state
    state(i+1) = next_state;

end

end