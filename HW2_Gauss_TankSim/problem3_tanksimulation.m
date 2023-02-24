% Simulating a tank filling/emptying
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

% normal height
h(1) = h0;

% noisy height
h_noise(1) = h0;
h_mu = 0;
h_sigma = 1;

% measurement
z_mu = 0;
z_sigma = 10000;

% timing
t_start = 0;
t_end = 100;
dt = 0.2;

% simulation
t = t_start:dt:t_end;
for i = 1:length(t)

    % calc flows
    f1 = sin(t(i)/2);
    f2 = cos(t(i)/3);
    u = [f1; f2];

    % calc no noise height (ideal, nonimal)
    h(i+1) = h(i) + ...
             A*h(i)*dt + ...
             B*u*dt;

    % calc noisy height (real)
    h_noise(i+1) = h_noise(i) + ... 
                   A*h_noise(i)*dt + ...
                   B*u*dt + ...
                   normrnd(h_mu,h_sigma)*dt;  % add error term  

    % calc pressure (measurement)
    z(i) = C*h_noise(i+1) ...
        + normrnd(z_mu,z_sigma);

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
legend('ideal (no noise)','real (w/ noise)','pressure')
