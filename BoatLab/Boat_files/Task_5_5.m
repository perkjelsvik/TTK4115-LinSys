%% Init
close  all 
clc
clear  variables 

figNum = 1;         % Figure number-counter
PSI_r = 30;         % Reference angle for simulation
sim_t = 500;        % Simulation time

% \\\ Constants from previous tasks 
addpath('Data-files')               % Add folder for .mat-files
load('constants_5.2.mat')           % K_w, lambda, omega_0, sigma
load('constants_5.3.mat')           % K, K_pd, T, T_d, T_f, w_c

% \\\ X and Y output of ship 
%     in task 5.3.b/c/d   ///
load('north_east_5.3.mat')          % x1, x2, x3, y1, y2, y3

% \\\ Rudder input to ship 
%     in task 5.3.b/c/d   ///
load('rudder_input_5.3.mat')         % delta1, delta2, delta3, t1, t2, t3

% \\\ Psi output of ship 
%     in task 5.3.b/c/d   ///
load('compass_measurment_5.3.mat')   % psi1, psi2, psi3

% \\\ Add working path for simulink models
addpath('Simulink models tasks')
%

%% Task 5.5.a ---- Exact discretization
% \\\ Matrices from Task 5.4.a
A = [0 1 0 0 0; -omega_0^2 -2*lambda*omega_0 0 0 0; 0 0 0 1 0; ...  
    0 0 0 -1/T -K/T; 0 0 0 0 0];
B = [0; 0; 0; K/T; 0];
C = [0 1 1 0 0];
D = 0;
E = [0 0; K_w 0; 0 0; 0 0; 0 1];

% \\\ Sample frequency
F_s = 10; 
T_s = 1/F_s;

% \\\ Exact discretization
[~, Bd]  = c2d(A,B,T_s);    Cd = C;
[Ad, Ed] = c2d(A,E,T_s);    Dd = D;
%

%% Task 5.5.b ---- Estimate of var(v)
load_system('task5_5_b.slx')
sim('task5_5_b.slx')

% \\\ R is the Measurment noise variance
R = var(sim_compass*pi/180);
%

%% Task 5.5.c ---- Discrete Kalman Filter
% \\\ Q is the Process noise covariance
Q = [30 0; 0 10^(-6)];
P_0 = [1 0 0 0 0; 0 0.013 0 0 0; 0 0 pi^2 0 0; 0 0 0 1 0; ...
    0 0 0 0 2.5*10^-4];
X_0 = [0; 0; 0; 0; 0];
R = R/T_s;
I = diag([1 1 1 1 1]);

% \\\ Put data in a struct for use in the Kalman filter
data = struct('Ad',Ad,'Bd',Bd,'Cd',Cd,'Ed', Ed, 'Q',Q,'R', R,'P_0',P_0, ...
              'X_0',X_0, 'I', I);
%

%% Task 5.5.d ---- Feed forward estimated bias
load_system('task5_5_d.slx')
sim('task5_5_d.slx')

% \\\ Plot measured compass with and without estimated bias
figure(figNum)
figNum = figNum+1;
subplot(2,1,1)
plot(t,sim_PSI_r, 'r--', t, sim_compass, t2, psi2, 'LineWidth', 3)
title(['Compass reference $\psi_{r} = 30$, and measured $\psi$ with and'...
    ' without Kalman-estimated bias $\hat{b}$'], ...
    'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\psi_{r}$', '$\psi$ with $\hat{b}_{feedforward}$', ...
    '$\psi$ without $\hat{b}_{feedforward}$'}, 'FontSize', 24,  ...
    'Interpreter', 'latex', 'Location', 'SouthEast')
ax = gca; ax.FontSize = 24; grid  on ;

subplot(2,1,2)
plot(t, b_filtered,'m', t, delta, t2, delta2, 'LineWidth', 3)
title(['Kalman-estimated bias $\hat{b}$, and rudder input $\delta$ ' ...
'with and without Kalman-estimated bias $\hat{b}$'], ...
    'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\hat{b}$', '$\delta$ with $\hat{b}_{feedforward}$', ...
    '$\delta$ without $\hat{b}_{feedforward}$'}, 'FontSize', 24,  ...
    'Interpreter', 'latex', 'Location', 'SouthEast')
ax = gca; ax.FontSize = 24; grid on;

% \\\ Plotting North-East plot for this task and part 5.3
figure(figNum)
figNum = figNum+1;
plot(north_east(:,2),north_east(:,1),y2, x2, 'm', y1,x1,'r--', ...
    'LineWidth', 3);
title(['North-East plot of ship course with Kalman filtered current,'...
    'no waves'], 'FontSize', 24);
ylabel('North [m]', 'FontSize', 20); grid on;
xlabel('East [m]', 'FontSize', 20); 
legend({'With bias estimation (Kalman)', ...
    'Without bias estimation (with current disturbance)',...
    'No disturbances'}, 'FontSize', 26, 'Location', 'best');
ax = gca; ax.FontSize = 24; axis([0 500 0 1250]);
%

%% Task 5.5.e ---- Feed forward estimated bias and wave filtered psi
load_system('task5_5_e.slx')
sim('task5_5_e.slx')

% \\\ Plot measured compass and estimated compass
figure(figNum)
figNum = figNum+1;
plot(t,sim_PSI_r, 'r--', t, sim_compass, t, psi_filtered, 'LineWidth', 3)
title(['Compass reference $\psi_{r} = 30$, and measured course $\psi$ '...
    'with Kalman-estimated course $\hat{\psi} + \hat{\psi_{w}}$ ' ...
    'and bias $\hat{b}$'], 'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\psi_{r}$', ['$\psi + \psi_{w}$ with '...
    '$(\hat{\psi} + \hat{\psi}_{w})_{feedback}$ and '...
    '$\hat{b}_{feedforward}$'], ['$\hat{\psi} + \hat{\psi}_{w}$ '...
    'with $(\hat{\psi} + \hat{\psi}_{w})_{feedback}$ and '...
    '$\hat{b}_{feedforward}$']}, 'FontSize', 24,  ...
    'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on; axis([0 500 -5 40])

% \\\ Plot measured psi with and without Kalman filtered bias and waves
figure(figNum)
figNum = figNum+1;
plot(t,sim_PSI_r, 'r--', t, sim_compass, t3, psi3, 'LineWidth', 3)
title(['Compass reference $\psi_{r} = 30$, and measured $\psi$ with and'...
    ' without Kalman-estimated $\hat{\psi} + \hat{\psi_{w}}$ and bias '...
    '$\hat{b}$'], 'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\psi_{r}$', ['$\psi + \psi_{w}$ with '...
    '$(\hat{\psi} + \hat{\psi}_{w})_{feedback}$ and '...
    '$\hat{b}_{feedforward}$'], ['$\psi + \psi_{w}$ with '...
    '$(\psi + \psi_{w})_{feedback}$']}, 'FontSize', 24,  ...
    'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on; axis([0 500 -5 40])

% \\\ Plotting rudder input delta
figure(figNum)
figNum = figNum+1;
subplot(2,1,1)
plot(t, b_filtered,'m', t,delta, 'LineWidth', 3)
title('Rudder input $\delta$ and estimated bias $\hat{b}$', ...
    'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\hat{b}$', ['$\delta$ with '...
    '$(\hat{\psi} + \hat{\psi}_{w})_{feedback}$ and '...
    '$\hat{b}_{feedforward}$']}, 'FontSize', 24,  ...
    'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on;

subplot(2,1,2)
plot(t3, delta3, 'LineWidth', 3)
title(['Rudder input $\delta$ without Kalman filtered $\hat{\psi}$ '...
    'or $\hat{b}$'],'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\delta$ with $(\psi + \psi_{w})_{feedback}$'}, ...
    'FontSize', 24, 'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on;

% \\\ Plotting North-East plot compared to 5.3.d
figure(figNum)
figNum = figNum+1;
plot(north_east(:,2),north_east(:,1),y3, x3, 'm', y1,x1,'r--', ...
    'LineWidth', 3);
title(['North-East plot of ship course with Kalman filtered current '...
    'and waves'], 'FontSize', 24);
ylabel('North [m]', 'FontSize', 20); grid on;
xlabel('East [m]', 'FontSize', 20); 
legend({'With bias and wave estimation (Kalman)', ...
    'Without bias or wave estimation (with wave disturbance)', ...
    'No disturbances'}, 'FontSize', 26, 'Location', 'best');
ax = gca; ax.FontSize = 24; axis([0 500 0 1250]);


% \\\ Wave influence (current turned off, delta = 0)
load_system('task5_5_e_2.slx')
sim('task5_5_e_2.slx')

% \\\ Plotting wave influence on system
figure(figNum)
figNum = figNum+1;
subplot(2,1,1)
plot(t, sim_compass, t, psi_filtered, 'LineWidth', 3)
title(['Measured wave influence $\psi_{w}$ with and without '...
    'Kalman-estimated compass course $\hat{\psi}_{w}$ and bias '...
    '$\hat{b}$'], 'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\psi_{w}$', '$\hat{\psi}_{w}$'}, 'FontSize', 24,  ...
    'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on;

subplot(2,1,2)
plot(t, b_filtered,'m', t,delta, 'LineWidth', 3)
title('Rudder input $\delta$ and estimated bias $\hat{b}$', ...
    'FontSize', 24, 'Interpreter', 'latex');
xlabel('t [s]', 'FontSize', 20); ylabel('Angle [deg]', 'FontSize', 20);
legend({'$\hat{b}$ with $\hat{\psi_{w}}_{feedback}$', '$\delta$'}, ...
    'FontSize', 24, 'Interpreter', 'latex', 'Location', 'best')
ax = gca; ax.FontSize = 24; grid on;
%