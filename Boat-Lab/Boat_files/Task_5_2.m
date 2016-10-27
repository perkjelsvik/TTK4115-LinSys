%% Init
close all
clc
clear all

figNum = 1;
%

%% TASK 5.2.a ---- Estimate PSD 
load('wave.mat');

F_s = 10;
window = 4096;
noverlap = [];
nfft = [];  

%sp�r stud.ass! Grader/rad fra waves.mat, har det noe � si?? Riktig her?
[pxx,f] = pwelch(psi_w(2,:).*(pi/180),window,noverlap,nfft,F_s);

omega = 2*pi.*f;
pxx = pxx./(2*pi);
%

%% TASK 5.2.c ---- Find omega_0
figure(figNum)
plot(omega,pxx)
hold on
xlabel('\omega', 'FontSize', 18)
ylabel('$$S_{\varphi_{w}}(w)$$', 'FontSize', 20, 'Interpreter', 'latex')
title('Estimated PSD $$S_{\varphi_{w}}(w)$$ of waves', 'FontSize', 20, ...
    'Interpreter', 'latex')

[maxPSD, indexAtMaxPSD] = max(pxx);
omega_0 = omega(indexAtMaxPSD);
plot(omega_0, maxPSD, 'ro');
a = annotation('textarrow', [0.2 0.15], [0.8 0.91], 'String', '\omega_0');
a.Color = 'red';
a.FontSize = 20;
hold off
%