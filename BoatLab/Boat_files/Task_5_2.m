%% Init
close all
clc
clear variables

figNum = 1;
load('wave.mat');
%

%% TASK 5.2.a ---- Estimate PSD 
F_s = 10;
window = 4096;
noverlap = [];
nfft = [];  

[pxx,f] = pwelch(psi_w(2,:).*(pi/180),window,noverlap,nfft,F_s);

omega = 2*pi.*f;
pxx = pxx./(2*pi);
%

%% TASK 5.2.c ---- Find omega_0
figure(figNum)
figNum = figNum+1;
plot(omega,pxx, 'LineWidth', 4)
axis([0 2 -0.00005 16*10^(-4)])
hold on
xlabel('$\omega$ [$\frac{rad}{s}$]', 'FontSize', 20, 'Interpreter', 'latex')
ylabel('$S_{\psi_{w}}(\omega)$ [rad]', 'FontSize', 20, 'Interpreter', 'latex')
title('Estimated PSD $S_{\psi_{w}}(\omega)$ of waves', 'FontSize', 20, ...
    'Interpreter', 'latex')
grid on; 

ax = gca; ax.XTick = [0:pi/8:2];
ax.XTickLabel = {'$0$', '$\frac{\pi}{8}$', '$\frac{\pi}{4}$', '$\frac{3\pi}{8}$', ...
    '$\frac{\pi}{2}$','$\frac{5\pi}{8}$', '$\frac{3\pi}{4}$'};
ax.TickLabelInterpreter = 'latex';
ax.FontSize = 24;

[maxPSD, indexAtMaxPSD] = max(pxx);
omega_0 = omega(indexAtMaxPSD);

plot(omega_0, maxPSD, 'ro', 'MarkerSize', 10);
a = annotation('textarrow', 2.15*[0.23 0.203], [0.79 0.866], 'String', ... 
    '($\omega_0, S_{\psi_{w}}(\omega_0)$)', 'Interpreter', 'latex');
a.Color = 'red';
a.FontSize = 36;
hold off
%

%% TASK 5.2.d ---- Finding lambda
figure(figNum)
figNum = figNum+1;
plot(omega,pxx, 'LineWidth', 3)
axis([0 2 -0.00005 16*10^(-4)])
hold on
xlabel('$\omega$ [$\frac{rad}{s}$]', 'FontSize', 20, 'Interpreter', 'latex')
ylabel('$S_{\psi_{w}}(\omega)$, $P_{\psi_{w}}(\omega)$ [rad]', 'FontSize', 20, ...
    'Interpreter', 'latex')
title('Estimated $S_{\psi_{w}}(\omega)$ vs. analytical $P_{\psi_{w}}(\omega)$', ...
    'FontSize', 20, 'Interpreter', 'latex')
grid on

ax = gca; ax.XTick = 0:pi/8:2;
ax.XTickLabel = {'$0$', '$\frac{\pi}{8}$', '$\frac{\pi}{4}$', '$\frac{3\pi}{8}$', ...
    '$\frac{\pi}{2}$','$\frac{5\pi}{8}$', '$\frac{3\pi}{4}$'};
ax.TickLabelInterpreter = 'latex';
ax.FontSize = 24;

sigma = sqrt(maxPSD);
for lambda=0.04:0.04:0.16

K_w = 2*lambda*omega_0*sigma;
pxx_a = (omega.*K_w).^2./(omega.^4 + omega_0^4 + 2*omega_0^2*omega.^2*(2*lambda^2-1));
plot(omega, pxx_a, '--', 'LineWidth', 2);
end
legend({'$S_{\psi_{w}}(\omega)$', '$\lambda = 0.04$', '$\lambda = 0.08$', '$\lambda = 1.2$', ...
    '$\lambda = 1.6$'}, 'Interpreter', 'latex', 'FontSize', 24, 'Location', 'northwest');
hold off

% More accurate lambda plotting
figure(figNum)
figNum = figNum+1;
plot(omega,pxx, 'LineWidth', 3)
axis([0 2 -0.00005 16*10^(-4)])
hold on
xlabel('$\omega$ [$\frac{rad}{s}$]', 'FontSize', 20, 'Interpreter', 'latex')
ylabel('$S_{\psi_{w}}(\omega)$, $P_{\psi_{w}}(\omega)$ [rad]', 'FontSize', 20, ...
    'Interpreter', 'latex')
title('Estimated $S_{\psi_{w}}(\omega)$ vs. analytical $P_{\psi_{w}}(\omega)$', ...
    'FontSize', 20, 'Interpreter', 'latex')
grid on

ax = gca; ax.XTick = [0:pi/8:2];
ax.XTickLabel = {'$0$', '$\frac{\pi}{8}$', '$\frac{\pi}{4}$', '$\frac{3\pi}{8}$', ...
    '$\frac{\pi}{2}$','$\frac{5\pi}{8}$', '$\frac{3\pi}{4}$'};
ax.TickLabelInterpreter = 'latex';
ax.FontSize = 24;

for lambda=0.07:0.01:0.10
K_w = 2*lambda*omega_0*sigma;
pxx_a = (omega.*K_w).^2./(omega.^4 + omega_0^4 + 2*omega_0^2*omega.^2*(2*lambda^2-1));
plot(omega, pxx_a, '--', 'LineWidth', 2);
end
legend({'$S_{\psi_{w}}(\omega)$', '$\lambda = 0.07$', '$\lambda = 0.08$', ...
    '$\lambda = 0.9$', '$\lambda = 1.0$'},  ... 
    'Interpreter', 'latex', 'FontSize', 24, 'Location', 'northwest');
hold off

%choose lambda to be 0.08
lambda = 0.08;
%