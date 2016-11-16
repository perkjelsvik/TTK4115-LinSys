%% Init
close all
clc
clear variables

addpath('Data-files')
% \\\ Constants from previous tasks (witout disturbances)
load('constants_5.2.mat')
load('constants_5.3.mat')
%

%% TASK 5.4.a ---- Finding A, B, C and E
A_bw = [0 1 0 0 0; -omega_0^2 -2*lambda*omega_0 0 0 0; 0 0 0 1 0; ...
    0 0 0 -1/T -K/T; 0 0 0 0 0];
B_bw = [0; 0; 0; K/T; 0];
C_bw = [0 1 1 0 0];
E_bw = [0 0; K_w 0; 0 0; 0 0; 0 1];
%

%% TASK 5.4.b ---- Observabillity without disturbances
A = [0 1; 0 -1/T];
B=[0; K/T];
C= [1 0];
O = obsv(A,C);

% \\\ If rank(O) = 2, we have full rank <=> Observabillity
rank_O = rank(O);
%

%% TASK 5.4.c ---- Observabillity with current
A_b = [0 1 0; 0 -1/T -K/T; 0 0 0]; 
C_b = [1 0 0];
O_b = obsv(A_b,C_b);

% \\\ If rank(O_b) = 3, we have full rank <=> Observabillity
rank_O_b = rank(O_b);
%

%% TASK 5.4.d ---- Observabillity with wave
A_w = [0 1 0 0; -omega_0^2 -2*lambda*omega_0 0 0; 0 0 0 1; 0 0 0 -1/T];
C_w = [0 1 1 0];
O_w = obsv(A_w,C_w);

% \\\ If rank(O_w) = 4, we have full rank <=> Observabillity
rank_O_w = rank(O_w);
%

%% TASK 5.4.e ---- Observabillity with current and wave
O_bw = obsv(A_bw,C_bw);

% \\\ If rank(O_bw) = 5, we have full rank <=> Observabillity
rank_O_bw = rank(O_bw); 
%

%% ------- PRINT RESULTS ---------
fprintf(['\n\n\t\t*-------------------------------'...
    '---------------------------*\n']);
fprintf(['\t\t| \t  TABLE\t\t| ideal\t|current|  wave\t| '...
    'current and wave |\n']);
fprintf(['\t\t*-----------------------------------'...
    '-----------------------*\n']);
fprintf('\t\t| required rank\t|\t2\t|\t3\t|\t4\t|\t\t  5\t\t   |\n');
fprintf('\t\t|  actual rank\t|\t%i\t|\t%i\t|\t%i\t|\t\t  %i \t   |\n', ...
    rank_O, rank_O_b, rank_O_w, rank_O_bw);
fprintf('\t\t|  Observable?\t|  Yes\t|  Yes\t|  Yes\t|\t\t Yes\t   |\n');
fprintf(['\t\t*-----------------------------------'...
    '-----------------------*\n\n']);
%