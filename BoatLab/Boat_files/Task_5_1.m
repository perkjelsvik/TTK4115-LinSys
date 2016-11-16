%% Init
close all
clc
clear variables

figNum = 1;             % Figure number-counter
w_1 = 0.005;            % For use in 5.1.b and 5.1.c
w_2 = 0.05;             % For use in 5.1.b and 5.1.c

% \\\ Load previously simulated data from .mat-files
addpath('Data-files')
load('omega_1.mat')     % 5.1.b - omega_1 is system output 
load('omega_2.mat')     % 5.1.b - omega_2 is system output 
load('omega_1_E.mat')   % 5.1.c - omega_1_E is system output 
load('omega_2_E.mat')   % 5.1.c - omega_2_E is system output 
%

%% TASK 5.1.b ---- Without disturbance
H_1 = omega_1;
H_2 = omega_2;
t = length(H_1);

% \\\ Plot system output without waves or noise
figure(figNum); figNum = figNum + 1;
subplot(2,1,1)
plot(H_1(:,1),H_1(:,2), 'LineWidth', 3)
xlabel('t [s]', 'FontSize', 18); ylabel('$Sin(\omega_{1}t)$ [deg])', ... 
    'FontSize', 18, 'Interpreter', 'latex')
title('Sinus-input where \omega_{1} = 0.005 for model without noise', ...
    'FontSize', 24); 
set(gca,'FontSize',14); grid on;

subplot(2,1,2)
plot(H_2(:,1),H_2(:,2),'r', 'LineWidth', 3)
xlabel('t [s]', 'FontSize', 18); ylabel('$Sin(\omega_{2}t)$ [deg]', ... 
    'Interpreter', 'latex', 'FontSize', 18);
title('Sinus-input where \omega_2 = 0.05 for model without noise', ... 
    'FontSize', 24)
set(gca,'FontSize',14); grid on;

% \\\ Find ampltiude peaks
A_11 = max(H_1(3500:t,2));
A_12 = min(H_1(3500:t,2));
A_21 = max(H_2(3500:t,2));
A_22 = min(H_2(3500:t,2));

% \\\ Average amplitude value of output
A_1 = (A_11-A_12)/2;
A_2 = (A_21-A_22)/2;

% \\\ Finding K and T from system output 
K = sqrt((A_1^2*w_1^2- ((A_1^2*A_2^2*w_1^4*w_2^2)/(w_2^4*A_2^2)))...
    /(1-(A_1^2*w_1^4)/(w_2^4*A_2^2)));
T = (sqrt(K^2 - A_2^2*w_2^2))/(w_2^2*A_2);
%

%% TASK 5.1.c ---- with disturbance
H_1_E = omega_1_E;
H_2_E = omega_2_E;
t_E = length(H_1_E);

% \\\ Plot system output with waves and noise
figure(figNum)
figNum = figNum + 1;
subplot(2,1,1)
plot(H_1_E(:,1),H_1_E(:,2), 'LineWidth', 3)
xlabel('t [s]', 'FontSize', 18); ylabel('Sin($$\omega_{1}$$t) [deg]', ...
    'Interpreter', 'latex','FontSize', 18)
title('Sin-input where \omega_1 = 0.005 for model with waves and noise',...
    'FontSize', 24)
set(gca,'FontSize',14); grid on;

subplot(2,1,2)
plot(H_2_E(:,1),H_2_E(:,2),'r', 'LineWidth', 1)
xlabel('t [s]', 'FontSize', 18); ylabel('Sin($$\omega_{2}$$t) [deg]', ... 
    'Interpreter', 'latex', 'FontSize', 18)
title('Sinus where \omega_2 = 0.05 for model with waves and noise', ... 
    'FontSize', 24)
set(gca,'FontSize',14), grid on;

% \\\ Find amplitude peaks
A_11_E = max(H_1_E(3500:t_E,2));
A_12_E = min(H_1_E(3500:t_E,2));
A_21_E = max(H_2_E(3500:t_E,2));
A_22_E = min(H_2_E(3500:t_E,2));

% \\\ Average amplitude for w_1
A_1_E = (A_11_E - A_12_E)/2;

% \\\ Attempt to find average value of amplitude for w_2
s_w_2 = 0;
for i=4000:8000
    A_max = max(H_2_E(i-100:i+100,2));
    A_min = min(H_2_E(i-100:i+100,2));
    s_w_2 = s_w_2 + (A_max-A_min)/2;
end

A_2_E = s_w_2/4000;

% \\\ Finding K and T from system output
K_E = sqrt((A_1_E^2*w_1^2- ((A_1_E^2*A_2_E^2*w_1^4*w_2^2)/...
    (w_2^4*A_2_E^2)))/(1-(A_1_E^2*w_1^4)/(w_2^4*A_2_E^2)));
T_E = (sqrt(K_E^2 - A_2_E^2*w_2^2))/(w_2^2*A_2_E);
%

%% TASK 5.1.d ---- Step response
load('step_simulink.mat')

% \\\ Define transfer function
H_tf = tf(K, [T 1 0]);

% \\\ Plot step response of ship and model
figure(figNum);
figNum = figNum + 1;
H_tf_sim = step_simulink;
step(H_tf,length(H_tf_sim)/2)
hold on;
plot(H_tf_sim(:,1),H_tf_sim(:,2),'r', 'LineWidth', 4)
title('Step response of ship and model', 'FontSize', 24)
legend({'$$Step_{model}$$', '$$Step_{ship}$$'}, 'FontSize', 36, ... 
    'Interpreter', 'latex');
grid on; hold off;
xlabel('Time ','FontSize', 24); ylabel('Amplitude [deg]','FontSize', 24);
set(gca,'FontSize',14)
%