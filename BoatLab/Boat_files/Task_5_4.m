%% Init
close all
clc
clear all

addpath('Data-files')
% Constants from previous tasks witout disturbances
load('constants_5.2.mat')
load('constants_5.3.mat')
%

%% TASK 5.4.a ---- Finding A, B, C and E
A_bw = [0 1 0 0 0; -omega_0^2 -2*lambda*omega_0 0 0 0; 0 0 0 1 0; ...
    0 0 0 -1/T -K/T; 0 0 0 0 0];
B_bw = [0 0 0 K/T 0];
C_bw = [0 1 1 0 0];
E_bw = [0 0; K_w 0; 0 0; 0 0; 0 1];
%

%% TASK 5.4.b ---- Observabillity without disturbances
A =
C = 

% If C_obs = , we have full rank <=> Observabillity
C_obs = rank(obsv(A,C));
%

%% TASK 5.4.c ---- Observabillity with current
A_b =  
C_b =

% If C_obs_b = 5, we have full rank <=> Observabillity
C_obs_b = rank(obsc(A_b,C_b));
%

%% TASK 5.4.d ---- Observabillity with wave
A_w = 
C_w = 

% If C_obs_w = 5, we have full rank <=> Observabillity
C_obs_w = rank(obsc(A_w,C_w));
%

%% TASK 5.4.e ---- Observabillity with current and wave
% If C_obs_bw = 5, we have full rank <=> Observabillity
C_obs_bw = rank(obsv(A_w,C_w));
%
