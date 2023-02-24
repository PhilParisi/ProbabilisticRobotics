% Simulating a tank flying drone
clc, clearvars, close all

% system model
    % x_dot = Ax + Bu + epsilon     [rate of state change]
    % z = Cx + Du + del             [measurement]

% discretized model
    % x_dot ~= (x_t+1 - x_t) / dt
    % Ax + Bu + epsilon = (x_t+1 - x_t) / dt 
    % x_t+1 = x_t + Ax*dt + Bu*dt + epsilon*dt

% state --> X = [height; velocity] 
% x_dot = [velocity; accel] 
% input --> u = acceleration
% measure the height only --> Z = Cx + del, C = [1 0]

% params
x0 = 10; %m (initial drone height)
v0 = 0; %m/s (initial drone velocity

% system matrices
A = [0 1; 0 0]; %2x2
B = [0; 1];     %2x1
C = [1 0];
D = 0;

% noisy state (real)
x_t = [x0; v0]; % initial conditions
x_mu = [0; 0];  % two states, two noises (h and v)
x_sigma = [0.01 0.0;
           0.0  0.01];

% measurement noise
z_mu = 0;
z_sigma = 1; % std dev [m]

% timing
t_start = 0; t_end = 20; dt = 0.1;

% kalman conditions
mu_t = [0; 0];                  % mean value of state estimate, initially no idea
sigma_t = [0.00001 0.0;         % uncertainty of initial states
           0.0     0.00001];

A_t = eye(size(A)) + A*dt;
B_t = B*dt;
C_t = C;


% live plotting
figure(1)
plot(t_start,x_t(1),'b.'), hold on

% simulation
t = t_start:dt:t_end;
for i = t

    %%%%%% SYSTEM

    % acceleration is zero (stay still at height)
    a = 0.0; u = [a];

    % update state with motion model (x_t --> x_tp1)
    eps = mvnrnd(x_mu,x_sigma)'; % gives an nx1, need to transpose
    x_tp1 = x_t + A*x_t*dt + B*u*dt + eps*dt;
    plot(i, x_tp1(1), 'b.'), drawnow %plot state

    % take a measurement
    del = normrnd(z_mu, z_sigma);
    z = C*x_tp1 + del;
    plot(i, z, 'k.'), drawnow


    %%%%%% KALMAN
    
    % time update (bar means prediction)
    % before adding in measurement update, be sure to test this solo! change: x0 and a, and see how predicted responds
    mu_t_bar = A_t*mu_t + B_t*u;
    sigma_t_bar = A_t*sigma_t*A_t' + x_sigma; % add system noise Rt

    % measurement update
    K_t = sigma_t_bar * C_t'*inv(C_t*sigma_t_bar*C_t' + z_sigma); % Qt is measurement noise, sigma_z
    mu_tp1 = mu_t_bar + K_t*(z - C_t*mu_t_bar);
    sigma_tp1 = (eye(size(A)) - K_t*C_t) * sigma_t_bar;

    plot(i, mu_tp1(1),'g.'), drawnow

    %%%%%% VARIABLE UPDATES

    % update variables for next time step
    x_t = x_tp1; %update state
    mu_t = mu_tp1; %update prediction mean value
    sigma_t = sigma_tp1; %update prediction covariances

end

disp('sim finished')
figure(1), xlabel('time'), ylabel('height'), title('Drone Height over Time')
