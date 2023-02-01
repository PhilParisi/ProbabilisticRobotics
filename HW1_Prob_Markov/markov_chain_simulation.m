% Robotics HW 1 -- Phil Parisi -- 28Jan2023
% Markov Chain
clc, clearvars


%%% INITIAL PARAMETERS
tic

% number of days to simulate
days = 2000;
trials = 10000;

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


%% Steady State Calcs
% calculating the steady state of a markov chain
% create a system of equations

% Eqn 1, all probabilities in steady state must equal 1
    % p1 + p2 + p3

% Eqn 2, p1 must equal all other steady states entering state 1
    % p1 = p1(0.8) + p2(0.4) + p3(0.2)

% Eqn 3, p2 must equal all other steady states entering state 2
    % p2 = p1(0.2) + p2(0.4) + p3 (0.6)

% could also make an equation 4, but we now have 3 eqns and 3 unkowns

% solve using reduced row echelon form, linear algebra

A = [ 1.0 1.0 1.0 1.0;
     -0.2 0.4 0.2 0.0;
     0.2 -0.6 0.6 0.0];

rref(A) %final column shows [p1; p2; p3]

