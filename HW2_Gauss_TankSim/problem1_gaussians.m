% Problem 1 - MultiVariate Gaussians
clc, clearvars, close all


mu1 = [2 2]; % x_mean, y_mean

% Covariance Matrix Sigma, dxd matrix of covariances
    % if identity, then perfect 'circle'
Sigma1 = [1 0;   % sigmaX^2         sigmaXsigmaY
          0 2];  % sigmaYsigmaX     sigmaY^2
                    % Reqd: sigmaYsigmaX = sigmaXsigmaY
                  
% Dimensions must agree
x11 = -6:0.2:6; % for x-axis
x21 = -6:0.2:6; % for y-axis

[X11, X21] = meshgrid(x11,x21);

% Multivariate Normal PDF
F1 = mvnpdf([X11(:) X21(:)], mu1, Sigma1); % this is one huge column
F1 = reshape(F1, length(x11), length(x21)); % put in MxN

% Plot the first PDF
figure(1)
surf(x11,x21,F1);
xlabel('x11'),ylabel('x21'),zlabel('PDF F1')

%%%%%%%%%%%%%%%%%%%%%%%

mu2 = [-2 -2]; % x_mean, y_mean
Sigma2 = [1 1;   % sigmaX^2         sigmaXsigmaY
          1 2];  % sigmaYsigmaX     sigmaY^2

% Dimensions must agree
x12 = x11; % for x-axis
x22 = x21; % for y-axis

[X12, X22] = meshgrid(x12,x22);

% Multivariate Normal PDF
F2 = mvnpdf([X12(:) X22(:)], mu2, Sigma2); % this is one huge column
F2 = reshape(F2, length(x12), length(x22)); % put in MxN

% Plot the second PDF
figure(2)
surf(x12,x22,F2);
xlabel('x12'),ylabel('x22'),zlabel('PDF F2')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% combine the pdfs
BigF = F1 + F2;
figure(3)
surf(x11,x21,BigF);
xlabel('x'),ylabel('x'),zlabel('p(x,y)')
title('F1 + F2')

figure(4)
contour(x11,x21,BigF), grid on
xlabel('x'),ylabel('x'),
title('F1 + F2')
axis equal, hold on


% calculate eigen values and vectors
[v1, d1] = eig(Sigma1);
[v2, d2] = eig(Sigma2);

% the vectors are stored in the columns of v1 and v2 (f1)
plot([mu1(1) mu1(1) + v1(1,1)],[mu1(2), mu1(2) + v1(2,1)],'k-','linewidth',5)
plot([mu1(1) mu1(1) + v1(1,2)],[mu1(2), mu1(2) + v1(2,2)],'k-','linewidth',5)
% the vectors are stored in the columns of v1 and v2 (f2)
plot([mu2(1) mu2(1) + v2(1,1)],[mu2(2), mu2(2) + v2(2,1)],'k-','linewidth',5)
plot([mu2(1) mu2(1) + v2(1,2)],[mu2(2), mu2(2) + v2(2,2)],'k-','linewidth',5)


disp('Program Complete')

