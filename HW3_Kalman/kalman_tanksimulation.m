% Simulating a tank filling/emptying w/ a Kalman Filter
clc, clearvars, close all

% system model
    % x_dot = Ax + Bu + epsilon     [rate of state change]
    % z = Cx + Du + del             [measurement]

% discretized model
    % x_dot ~= (x_t+1 - x_t) / dt
    % Ax + Bu + epsilon = (x_t+1 - x_t) / dt 
    % x_t+1 = x_t + Ax*dt + Bu*dt + epsilon*dt

% params
g = 10; %m/s2 (gravity)
rho = 1000; %kg/m3 (density of freshwater)
h0 = 10; %m (initial tank height)
tank_area = 1; %m2 (base of tank)

% system matrices
A = [0]; B = [1 -1] ./ tank_area; C = rho*g; D = 0;

% timing
t_start = 0;
t_end = 100;
dt = 0.2;
t = t_start:dt:t_end;

% initial conditions
h(1) = h0;      % height

% noisy height
h_noise(1) = h0;
h_mu = 0;
h_sigma = 1; %0.00001; 

% measurement
z_mu = 0;
z_sigma = 10000;

% timing
t_start = 0;
t_end = 100;
dt = 0.2;

% kalman filter setup
A_t = eye(size(A)) + dt*A;
B_t = B*dt;
C_t = C;
mu = h0; % initial guess of state is initial tank height
Sigma = 0.00001; % we're confident in our intitial states 
R_t = 0.0001; % motion model noise
Q_t = z_sigma; % measurement noise
mu_saved = mu;
Sigma_saved = Sigma;


% simulation
for i = 1:length(t)

    % calc flows
    f1 = sin(t(i)/2);
    f2 = cos(t(i)/3);
    u = [f1; f2];

    % calc no noise height
    h(i+1) = h(i) + (f1-f2)/tank_area*dt;

    % calc noisy height
    h_noise(i+1) = h_noise(i) + ... 
                   A*h_noise(i)*dt + ...
                   B*u*dt + ...
                   normrnd(h_mu,h_sigma)*dt;    

    % calc pressure (measurement)
    z(i) = C*h_noise(i+1) ...
        + normrnd(z_mu,z_sigma);

    % kalman filter motion update
    %mu_bar(i+1) = A_t*mu(i) + B_t*u;
    %Sigma_bar(i+1) = A_t*Sigma(i)*A_t' + R_t; 
    mu_bar = A_t*mu + B_t*u;
    Sigma_bar = A_t*Sigma*A_t' + R_t; 

    % kalman filter measurement update
    %K_t = Sigma_bar(i+1)*C_t'*inv(C_t*Sigma_bar(i+1)*C_t' + Q_t);
    %mu(i+1) = mu_bar(i+1) + K_t*(z(i) - C_t*mu_bar(i+1));
    %Sigma(i+1) = (eye(length(C_t)) - K_t*C_t)*Sigma_bar(i+1);
    K_t = Sigma_bar*C_t'*inv(C_t*Sigma_bar*C_t' + Q_t)
    mu = mu_bar + K_t*(z(i) - C_t*mu_bar);
    Sigma = (eye(length(C_t)) - K_t*C_t)*Sigma_bar;

    % save the kalman variables
    mu_saved = [mu_saved mu];
    Sigma_saved = [Sigma_saved Sigma];

end

disp('sim finished')

%%%% Plots

% no noise and noisy height vs time
figure(1)
plot(t,h(1:end-1),'linewidth',2), xlabel('time (s)'), ylabel('height (m)')
title('Tank Height over Time'), grid on, hold on

plot(t,h_noise(1:end-1),'r-','linewidth',2)
legend('ideal (no noise)','real (w/ noise)')

% no noise h, noisy h, and pressure vs time
figure(2)
title('Tank Height over Time'), grid on, hold on
plot(t,h(1:end-1),'b-','linewidth',2), xlabel('time (s)'), ylabel('height (m)')
plot(t,h_noise(1:end-1),'r-','linewidth',2), hold on
plot(t,z(1:end)/10000,'m.','linewidth',1)
plot(t,mu_saved(1:end-1),'ko')
legend('ideal (no noise)','real (w/ noise)','pressure','kalman')