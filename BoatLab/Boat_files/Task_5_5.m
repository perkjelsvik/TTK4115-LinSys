%% Init
close all
clc
clear variables

figNum = 1;     % Figure number-counter
PSI_r = 30;     % Reference angle for simulation
sim_t = 500;    % Simulation time

% Constants from previous tasks without disturbances
addpath('Data-files')
load('constants_5.2.mat')
load('constants_5.3.mat')
% Simulink models
addpath('Simulink models tasks')
%

%% Task 5.5.a ---- Exact discretization
% Matrices from Task 5.4.a

A = [0 1 0 0 0; -omega_0^2 -2*lambda*omega_0 0 0 0; 0 0 0 1 0; ...
    0 0 0 -1/T -K/T; 0 0 0 0 0];
B = [0; 0; 0; K/T; 0];
C = [0 1 1 0 0];
D = 0;
E = [0 0; K_w 0; 0 0; 0 0; 0 1];

%Sample frequency
F_s = 10; 
T_s = 1/F_s;

%Exact discretization
[~, Bd]  = c2d(A,B,T_s);    Cd = C;
[Ad, Ed] = c2d(A,E,T_s);    Dd = D;
%

%% Task 5.5.b ---- Estimate of var(v)
load_system('task5_5_b.slx')
sim('task5_5_b.slx')
% R is the Measurment noise variance
R = var(sim_compass*pi/180);
%

%% Task 5.5.c ---- Discrete Kalman Filter
% Q is the Process noise covariance
Q = [30 0; 0 10^(-6)];
P_0 = [1 0 0 0 0; 0 0.013 0 0 0; 0 0 pi^2 0 0; 0 0 0 1 0; 0 0 0 0 2.5*10^-4];
X_0 = [0; 0; 0; 0; 0];
R = R/T_s;
I = diag([1 1 1 1 1]);

data = struct('Ad',Ad,'Bd',Bd,'Cd',Cd,'Ed', Ed, 'Q',Q,'R', R,'P_0',P_0, ...
              'X_0',X_0, 'I', I);
%

%% Task 5.5.d ---- Feed forward estimated bias
load_system('task5_5_d.slx')
sim('task5_5_d.slx')

figure(figNum)
figNum = figNum+1;
plot(t,sim_PSI_r, 'r--', t, sim_compass, t, b_filtered, 'c', 'LineWidth', 3)
title('Measured compass course $\psi$, rudder input $\psi_{r} = 30$ and estimated bias $b$', ...
    'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\psi_{r}$', '$\psi$', '$\hat{b}$'}, 'FontSize', 36,  ...
    'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on;
%

%% Task 5.5.e ---- Feed forward estimated bias and wave filtered psi
load_system('task5_5_e.slx')
sim('task5_5_e.slx')

figure(figNum)
figNum = figNum+1;
plot(t,sim_PSI_r, 'r--', t, sim_compass, t, psi_filtered, 'm', 'LineWidth', 3)
title('Measured compass course $\psi$, rudder input $\psi_{r} = 30$ and estimated compass $\psi$', ...
    'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\psi_{r}$', '$\psi + \psi_{w}$', '$\psi + \hat{\psi_{w}}$'}, 'FontSize', 36,  ...
    'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on;

%