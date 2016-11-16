%% Init
close all
clc
clear variables

figNum = 1;     % Figure number-counter
PSI_r = 30;     % Reference angle for simulation
sim_t = 500;    % Simulation time

% \\\ Simulink models
addpath('Simulink models tasks')
%

%% TASK 5.3.a ---- Designing a PD-controller
% \\\ Setting up transfer variable s and constants
s = tf('s');
K = 0.1742;
T = 86.5256;
T_d = T;
w_c = 0.1;

% \\\ Defining the transfer function
T_f = -1/(tan(130*pi/180)*w_c);
K_pd = sqrt(w_c^2+T_f^2*w_c^4)/K;
H_0 = (K*K_pd)/(s*(1+T_f*s));

% \\\ Bode margin plot of transfer function
figure(figNum)
figNum = figNum + 1;
margin(H_0); grid on; 
%

%% TASK 5.3.b ---- Simulating without disturbances
load_system('task5_3_b.slx')
sim('task5_3_b.slx')

% \\\ Plot of autopilot wihtout current and waves
figure(figNum)
figNum = figNum+1;
plot(t,sim_PSI_r, 'r--',t,sim_compass, t, delta, 'LineWidth',3);
title('Autopilot without current or waves', 'FontSize', 24);
xlabel('t [s]', 'FontSize', 20); grid on;
ylabel('$\mathbf{\psi_{r}(t), \ \psi(t), \ \delta}$ [deg]', ...
    'FontSize', 20, 'Interpreter', 'latex'); 
legend({'$\psi_{r}$', '$\psi$', '$\delta$'}, 'Location', ... 
    'best', 'FontSize', 36, 'Interpreter', 'latex')
ax = gca; ax.FontSize = 24;

% \\\ Save delta and north-east data for later plotting
delta1 = delta; t1 = t; psi1 = sim_compass;
x1 = north_east(:,1); y1 = north_east(:,2);
%

%% TASK 5.3.c --- Simulating with current, without waves
load_system('task5_3_c.slx')
sim('task5_3_c.slx')

% \\\ Plot of autopilot with current, but without waves
figure(figNum)
figNum = figNum + 1;
plot(t,sim_PSI_r, 'r--',t,sim_compass, t, delta, 'LineWidth',3);
xlabel('t [s]', 'FontSize', 20); grid on;
ylabel('$\mathbf{\psi_{r}(t), \ \psi(t), \ \delta}$ [deg]', ...
    'FontSize', 20, 'Interpreter', 'latex');
title('Autopilot with current, but without waves', 'FontSize', 24);
legend({'$\psi_{r}$', '$\psi$', '$\delta$'}, 'Location', ... 
    'best', 'FontSize', 36, 'Interpreter', 'latex')
ax = gca; ax.FontSize = 24;

% \\\ Save delta and north-east data for later plotting
delta2 = delta; t2 = t; psi2 = sim_compass;
x2 = north_east(:,1); y2 = north_east(:,2);
%

%% TASK 5.3.d --- Simulating with waves, without current
load_system('task5_3_d.slx')
sim('task5_3_d.slx')

% \\\ Plot of autopilot with waves and without current
figure(figNum)
figNum = figNum + 1;
plot(t,sim_PSI_r,'r--',t,sim_compass, t, delta, 'LineWidth',3);
xlabel('t [s]', 'FontSize', 20); grid on; ax = gca; ax.FontSize = 24;
ylabel('$\mathbf{\psi_{r}(t), \ \psi(t), \ \delta}$ [deg]', ... 
    'FontSize', 20, 'Interpreter', 'latex'); 
title('Autopilot with waves and without current', 'FontSize', 24);
legend({'$\psi_{r}$', '$\psi + \psi_{w}$', '$\delta$'}, 'Location', ... 
    'best', 'FontSize', 36, 'Interpreter', 'latex')

% \\\ Save delta and north-east data for later plotting
delta3 = delta; t3 = t; psi3 = sim_compass;
x3 = north_east(:,1); y3 = north_east(:,2);
%

%% Plotting the different rudder inputs against eachother
figure(figNum)
figNum = figNum+1;

% \\\ Subplot for delta with no disturbance and current disturbance
subplot(2,1,1)
plot(t1,delta1,t2,delta2,'LineWidth', 2);
title('Rudder input \delta with and without current', 'FontSize', 24); 
xlabel('t [s]', 'fontSize', 20); grid on;
ylabel('\delta [deg]', 'FontSize', 20);
legend({'\delta no disturbance', '\delta with current'}, 'Location', ...
    'best', 'FontSize', 36) 
axis([0 150 -30 40]); ax = gca; ax.FontSize = 24;

% \\\ Subplot for delta with wave disturbance
subplot(2,1,2);
plot(t3,delta3,'LineWidth',2); xlabel('t [s]', 'FontSize', 20);
title('Rudder input \delta with waves', 'FontSize', 24);
ylabel('\delta [deg]', 'FontSize', 20); grid on;
legend({'\delta with waves'}, 'Location', 'best', 'FontSize', 36) 
axis([0 150 -40 40]); ax = gca; ax.FontSize = 24;
%

%% Plotting North-East plot
figure(figNum)
figNum = figNum+1;

% \\\ Plot North-East plot for previous cases
plot(y1,x1,'r--',y2,x2,y3,x3,'m', 'LineWidth', 3);
title('North-East plot of ship course', 'FontSize', 24);
ylabel('North [m]', 'FontSize', 20); grid on;
xlabel('East [m]', 'FontSize', 20); 
ax = gca; ax.FontSize = 24; axis([0 150 0 600]);
legend({'Without disturbances', 'With current', ... 
    'With waves'}, 'Location', 'best', 'FontSize', 36)
%