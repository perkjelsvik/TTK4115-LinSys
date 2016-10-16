%% INITIAL SETUP
% This file contains the initialization for the helicopter assignment in
% the course TTK4115. Run this file before you execute QuaRC_ -> Build 
% to build the file heli_q8.mdl.

% Oppdatert høsten 2006 av Jostein Bakkeheim
% Oppdatert høsten 2008 av Arnfinn Aas Eielsen
% Oppdatert høsten 2009 av Jonathan Ronen
% Updated fall 2010, Dominik Breu
% Updated fall 2013, Mark Haring
% Updated spring 2015, Mark Haring

% Filer lagres på C:\ProgramData\QUARC\spool\win64

%%%%%%%%%%% Calibration of the encoder and the hardware for the specific
%%%%%%%%%%% helicopter
Joystick_gain_x = 1.5;
Joystick_gain_y = -3;


%%%%%%%%%%% Physical constants
g = 9.81; % gravitational constant [m/s^2]
l_c = 0.46; % distance elevation axis to counterweight [m]
l_h = 0.66; % distance elevation axis to helicopter head [m]
l_p = 0.175; % distance pitch axis to motor [m]
m_c = 1.92; % Counterweight mass [kg]
m_p = 0.72; % Motor mass [kg]
%

%% *----------------- Part I - Mathematical Modeling --------------------*

%% |-- Task 5.1.2 - Linearization --|

K_1 = K_f/(2*m_p*l_p);
K_2 = (K_f*l_h)/(m_c*l_c^2+2*m_p*l_h^2);
K_3 = g*(m_c*l_c-2*m_p*l_h)/(m_c*l_c^2+2*m_p*(l_h^2+l_p^2));
%

%% |-- Task 5.1.4 - Finding motor constant --|
V_s_star = 6.2673;
K_f = -(g*(m_c*l_c-2*m_p*l_h))/(V_s_star*l_h);
%K_f = 0.1594;
%



%% *---------------- Part II - Monovariable control ---------------------*

%% |-- Task 5.2.1 - PD controller --|
%Omega_0 = pi;
Omega_0 = 0.558*pi;
%zeta = 1;
Zeta = 0.875;
K_pp = (Omega_0)^2/K_1;
K_pd = 2*Zeta*sqrt(K_pp/(K_1));

%Closed loop
s=tf('s');
H_PD = (K_1*K_pd)/(s^2 + K_1*K_pd*s + K_1*K_pp);
%margin(G)
figure(1)
step(H_PD)
grid on 

%Open loop
G_PD = (K_1*K_pp)/(s^2 + K_1*K_pp*s);
%K_pp = 1.115
%margin(OL)
%nyquist(OL)
%rlocus(OL)
%

%% |-- Task 5.2.2 - Travel rate controller --|
%K_rp = -pi/2;
K_rp = -Omega_0/2;

%H_TR = (K_3*K_rp)/(s+K_3*K_rp);
%Skal vi bruke det her? plotting i rapport, pol-begrunnelse
%EIG1 = eig(H_PD);
%EIG2 = eig(H_TR);
%plot(real(EIG1), imag(EIG1),'rx', real(EIG2), imag(EIG2), 'ro');
%grid on
%



%% *---------------- PART III - Multivariable control -------------------*

%% |-- Task 5.3.2 - LQR --|
A = [0 1 0; 0 0 0; 0 0 0];
B = [0 0; 0 K_1; K_2 0];
C = [1 0 0; 0 0 1];
D = 0;
SYS_LQR = ss(A,B,C,D, 'StateName',{'p'; 'p_dot' ;'e_dot'}, ...
    'InputName', {'V_s';'V_d'}, 'OutputName', {'p';'e_dot'});

Q = diag([100 30 100]);
R = diag([1 1]);
K = lqr(A,B,Q,R);

P = inv(C*inv(B*K-A)*B);
%

%% |-- Task 5.3.3 - Integral effect --|
A_PI = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 0; 0 0 1 0 0];
B_PI = [0 0; 0 K_1; K_2 0; 0 0; 0 0];
C_PI = [1 0 0 0 0; 0 0 1 0 0];
D_PI = 0;
SYS_LQR_I = ss(A_PI, B_PI, C_PI, D_PI, ... 
    'StateName',{'p'; 'p_dot' ;'e_dot' ; 'gamma' ; 'zeta'}, ...
    'InputName', {'V_s';'V_d'}, 'OutputName', {'p';'e_dot'});

Q_PI = diag([200 50 300 200 1000]);
R_PI = diag([1 1]);
K_PI = lqr(A_PI,B_PI,Q_PI,R_PI);

K_P_PI = K_PI(1:2,1:3);
P_PI = inv(C*inv(B*K_P_PI-A)*B);
%

    

%% *---------------- PART IV - State Estimation -------------------------*

%% |-- Oppgave 5.4.1 - Math for observer --|
A_L = [0 1 0 0 0 0; 0 0 0 0 0 0; 0 0 0 1 0 0; 0 0 0 0 0 0; 0 0 0 0 0 1; K_3 0 0 0 0 0];
B_L = [0 0; 0 K_1; 0 0; K_2 0; 0 0; 0 0];
C_L = [1 0 0 0 0 0; 0 0 1 0 0 0; 0 0 0 0 1 0];
D_L = 0;
SYS_L = ss(A_L, B_L, C_L, D_L, ... 
    'StateName',{'p'; 'p_dot' ; 'e'; 'e_dot' ; 'h' ; 'h_dot'}, ...
    'InputName', {'V_s';'V_d'}, 'OutputName', {'p';'e';'h'});

Q_L = diag([8 3 10 15 10 10]);
%Q_L = diag([1 1 200 50 1 300]);
R_L = diag([1 1]);
K_L = lqr(A_L, B_L, Q_L, R_L);
%

%% |-- Oppgave 5.4.2 - Observer --|
system_poles = eig(A_L-B_L*K_L);

r0 = max(abs(system_poles));

fr = 5;
phi = pi/8;
r = r0*fr;

spread = -phi:(phi/(2.5)):phi;

p=-r*exp(1i*spread);

figure(2)
plot(real(system_poles),imag(system_poles),'sr',real(p),imag(p),'kx');grid on; axis equal

L = transpose(place(transpose(A_L),transpose(C_L),p));
%

