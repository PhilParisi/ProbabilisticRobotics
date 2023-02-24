close all
clear all
clc

tmax = 100;
dt = 0.2;

t = 0:dt:tmax;

x_t = 10; %[m]
x_tn = 10; %[m]

plot(t(1),x_t,'bo')
hold on

mu=0;
sigma=1;

sigma_z = 10000;


for i=t
    
    r = normrnd(mu,sigma);
    
    f1 = sin(i/2);
    f2 = cos(i/3);
    
    x_tp1 = x_t + dt*[1 -1]*[f1 f2]';
    x_tp1n = x_tn + dt*[1 -1]*[f1 f2]'+dt*r;
    plot(i,x_t,'b.')
    plot(i,x_tn,'r.')
    
    nz = normrnd(0,sigma_z);

    z=1000*10*x_tp1n+nz;
    
    plot(i,z/10000,'k.')
    
    x_t = x_tp1;
    x_tn = x_tp1n;
    
end













