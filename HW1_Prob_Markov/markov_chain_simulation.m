% Robotics HW 1 -- Phil Parisi -- 28Jan2023
% Markov Chain
clc, clearvars


%%% INITIAL PARAMETERS
tic

% number of days to simulate
days = 20;
trials = 100000;

% Markov Chain (embedded into generate_weather.m)
prob = [0.8 0.2 0.0;            % sunny
        0.4 0.4 0.2;            % cloudy
        0.2 0.6 0.2];           % rainy

%%% SIMULATION

% Run trials
results(1:trials,1:days) = 0;

for i = 1:trials

    % generate a weather sequence
    weather = generate_weather(days);

    % add to the results matrix
    results(i,:) = weather;

end



%%% STATISTICS

% how many 1s, 2s, and 3s?
results = results(:,2:end);
total_nums = size(results,1)*size(results,2);
prob_1 = sum(sum(results == 1)) / total_nums;
prob_2 = sum(sum(results == 2)) / total_nums;
prob_3 = sum(sum(results == 3)) / total_nums;

% display probabilities in a table
tb = table(prob_1,prob_2,prob_3);
disp(tb)

toc
disp('done!')
