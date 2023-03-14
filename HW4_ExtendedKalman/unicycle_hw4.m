% Extended Kalman Filter [March 2023]
% Unicycle robot model

clc, close all, clear all

%parameters
Tmax = 300; %300
DeltaT = 0.2;

x = 0;
y = 0;
th = 0;

%control input
v = 0.02;
om = 0.05;

figure;
plot(x,y,'bo');
hold on
axis equal

% noise on the state
sigma_x = 0.02;
sigma_y = 0.02;
sigma_th = 0.02;

% noise on the measurements
sigma_z = 0.1;

% EKF params
    % initial state estimates
    mu_x = 0;
    mu_y = 0;
    mu_th = 0;
    mu = [mu_x; mu_y; mu_th];

    % initial uncertainty estimates
    Sigma = [0.0001,    0,          0;
             0,         0.0001,     0;
             0,         0,          0.0001];

    % motion model noise
    Rt =    [sigma_x,   0,          0;
             0,         sigma_y,    0;
             0,         0,          sigma_z];

    % measurement model noise
    Qt =    [sigma_z,   0;
            0,         sigma_z];

for t=0:DeltaT:Tmax
    
    % actual robot state / path (we are blind to this)
    eps_x = normrnd(0, sigma_x);
    eps_y = normrnd(0, sigma_y);        % errors for below movements
    eps_th = normrnd(0, sigma_th);
    
    th_new = th+DeltaT*om + DeltaT*eps_th;
    x_new = x+DeltaT*v*cos((th_new+th)/2) + DeltaT*eps_x; % movements
    y_new = y+DeltaT*v*sin((th_new+th)/2) + DeltaT*eps_y;

    delta_z1 = normrnd(0, sigma_z);
    delta_z2 = normrnd(0, sigma_z);     % errors in measurement
    z = [x^2; y^2] + [delta_z1 ; delta_z2]; % measurement
    
    
    % EKF TIME UPDATE

    % mu_t_bar = g(ut, mu_t-1)
    mu_new(3) = mu(3) + DeltaT*om;
    mu_new(1) = mu(1) + DeltaT*v*cos( (mu_new(3) + mu(3)) / 2);
    mu_new(2) = mu(2) + DeltaT*v*sin( (mu_new(3) + mu(3)) / 2);

    % Sigma_t_bar = Gt Sigma_t-1 Gt' + Rt
    Gt = [1, 0, -v*sin(th)*DeltaT;
          0, 1,  v*cos(th)*DeltaT;
          0, 0,         1        ];

    Sigma = Gt * Sigma * Gt' + Rt;
    
    
    % EKF Measurement Update
    
    % Kt = Sigma_bar * Ht' * inv(Ht * Sigma_bar * Ht' + Qt)
    Ht = [2*mu_new(1),   0,               0;
          0              2*mu_new(2),     0];

    Kt = Sigma * Ht' * inv(Ht * Sigma * Ht' + Qt);
    
    % mu = mu_t_bar + Kt * (Z - h(mu_t_bar))
    mu_new = mu_new + Kt * (z - [mu_new(1)^2; mu_new(2)^2]);
    
    % Sigma = (I - Kt * Ht) * Sigma_bar
    Sigma = (eye(height(Kt)) - Kt * Ht) * Sigma;
    
    
    % update variables for next loop
    x = x_new;
    y = y_new;
    th = th_new;
    mu = mu_new;

    % live plot
    plot(x,y,'go'); hold on % actual path
    plot(mu(1), mu(2), 'ko') % EKF estimate
    pause(0.01)

    % switch control for fun!
    if t == 100
        om = 0;
        v = .03;
    end

end





