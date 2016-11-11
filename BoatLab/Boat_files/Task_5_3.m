%% Init
close all
clc
clear variables

figNum = 1;     % Figure number-counter
PSI_r = 30;     % Reference angle for simulation
sim_t = 500;    % Simulation time

% Simulink models
addpath('Simulink models tasks')
%

%% TASK 5.3.a ---- Designing a PD-controller
s = tf('s');
K = 0.1742;
T = 86.5256;
T_d = T;
w_c = 0.1;

T_f = -1/(tan(130*pi/180)*w_c);
K_pd = sqrt(w_c^2+T_f^2*w_c^4)/K;
H_0 = (K*K_pd)/(s*(1+T_f*s));

figure(figNum)
figNum = figNum + 1;
margin(H_0)
grid on
%

%% TASK 5.3.b ---- Simulating without disturbances
load_system('task5_3_b.slx')
sim('task5_3_b.slx')

figure(figNum)
figNum = figNum+1;
plot(t,sim_PSI_r, 'r--',t,sim_compass, 'LineWidth',3);
title('Autopilot without current and waves', 'FontSize', 24);
xlabel('t [s]', 'FontSize', 20); grid on;
ylabel('$\mathbf{\psi_{r}(t), \ \psi(t)}$ [deg]', 'FontSize', 20, 'Interpreter', 'latex'); 
legend({'$\psi_{r}(t)$', '$\psi(t)$'}, 'Location', ... 
    'best', 'FontSize', 36, 'Interpreter', 'latex')
%

%% TASK 5.3.c --- Simulating with current
load_system('task5_3_c.slx')
sim('task5_3_c.slx')

figure(figNum)
figNum = figNum + 1;
plot(t,sim_PSI_r, 'r--',t,sim_compass, 'LineWidth',3);
axis([0 500 0 35]); grid on
xlabel('t [s]', 'FontSize', 20); 
ylabel('$\mathbf{\psi_{r}(t), \ \psi(t)}$ [deg]', 'FontSize', 20, 'Interpreter', 'latex');
title('Autopilot with current, but without waves', 'FontSize', 24);
legend({'$\psi_{r}(t)$', '$\psi(t)$'}, 'Location', ... 
    'best', 'FontSize', 36, 'Interpreter', 'latex')
%

%% TASK 5.3.d --- Simulating with current and waves
load_system('task5_3_d.slx')
sim('task5_3_d.slx')

figure(figNum)
figNum = figNum + 1;
plot(t,sim_PSI_r,'r--',t,sim_compass, 'LineWidth',3);
axis([0 500 0 35]);grid on
xlabel('t [s]', 'FontSize', 20); 
ylabel('$\mathbf{\psi_{r}(t), \ \psi(t)}$ [deg]', 'FontSize', 20, 'Interpreter', 'latex'); 
title('Autopilot with waves and without current', 'FontSize', 24);
legend({'$\psi_{r}(t)$', '$\psi(t) + \psi_{w}(t)$'}, 'Location', ... 
    'best', 'FontSize', 36, 'Interpreter', 'latex')
%