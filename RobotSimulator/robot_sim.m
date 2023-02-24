% Robotic Simulator
% 2Feb2023
clc, clearvars, close all

% parameters
t_max = 10;
delta_t = 0.1;

v = 0.1; % m/s
omega = 0.1; % rad/s

% initial conditions
x0 = 0; y0 = 0; theta0 = 0;
state.x = x0;
state.y = y0;
state.theta = theta0;

% simulation
for t = 0:delta_t:t_max

    % update state 
    new_state.x = state.x + delta_t*v*cos(state.theta);
    new_state.y = state.y + delta_t*v*sin(state.theta);
    new_state.theta = state.theta + delta_t*omega;

    plot(state.x,state.y,'bo')
    pause(0.1)
    hold on

    state = new_state;

end