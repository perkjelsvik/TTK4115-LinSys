%% *----------------- INITIAL SETUP --------------------*
% This file contains the initialization for the helicopter assignment in
% the course TTK4115. Run this file before you execute QuaRC_ -> Build 
% to build the file heli_q8.mdl.

% Oppdatert høsten 2006 av Jostein Bakkeheim
% Oppdatert høsten 2008 av Arnfinn Aas Eielsen
% Oppdatert høsten 2009 av Jonathan Ronen
% Updated fall 2010, Dominik Breu
% Updated fall 2013, Mark Haring
% Updated spring 2015, Mark Haring

% Files are saved to C:\ProgramData\QUARC\spool\win64

%%%%%%%%%%% Calibration of the encoder and the hardware for the specific
%%%%%%%%%%% helicopter
Joystick_gain_x = 1.5;
Joystick_gain_y = -3; %Defined later in code, included for section-running

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
V_s_star = 6.5;
E_off = 0;
K_f = -(g*(m_c*l_c-2*m_p*l_h))/(V_s_star*l_h);
K_1 = K_f/(2*m_p*l_p);
K_2 = (K_f*l_h)/(m_c*l_c^2+2*m_p*l_h^2);
K_3 = g*(m_c*l_c-2*m_p*l_h)/(m_c*l_c^2+2*m_p*(l_h^2+l_p^2));
%


%% *---------------- Part II - Monovariable control ---------------------*

%% |-- Task 5.2.1 - PD controller --|
Omega_0 = 0.558*pi;
Zeta = 0.875;
K_pp = (Omega_0)^2/K_1;
K_pd = 2*Zeta*sqrt(K_pp/(K_1));

%Closed loop
s=tf('s');
H_PD = (K_1*K_pd)/(s^2 + K_1*K_pd*s + K_1*K_pp);
figure(1)
step(H_PD)
grid on

%Open loop
G_PD = (K_1*K_pp)/(s^2 + K_1*K_pp*s);
figure(2)
margin(G_PD)
%

%% |-- Task 5.2.2 - Travel rate controller --|
%The outer loop should be at least half the speed of the inner loop
K_rp = -Omega_0/2;
%


%% *---------------- PART III - Multivariable control -------------------*

%% |-- Task 5.3.2 - LQR --|
A = [0 1 0; 0 0 0; 0 0 0];
B = [0 0; 0 K_1; K_2 0];
C = [1 0 0; 0 0 1];
D = 0;
SYS_LQR = ss(A,B,C,D, 'StateName',{'p'; 'p_dot' ;'e_dot'}, ...
    'InputName', {'V_s';'V_d'}, 'OutputName', {'p';'e_dot'});

%Aggressive tuning
Q = diag([100 30 100]);
R = diag([0.1 1]);
K = lqr(A,B,Q,R);

P = inv(C*inv(B*K-A)*B);
%

%% |-- Task 5.3.3 - Integral effect --|
Joystick_gain_y = -1.5;
A_PI = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 0; 0 0 1 0 0];
B_PI = [0 0; 0 K_1; K_2 0; 0 0; 0 0];
C_PI = [1 0 0 0 0; 0 0 1 0 0];
D_PI = 0;
SYS_LQR_I = ss(A_PI, B_PI, C_PI, D_PI, ... 
    'StateName',{'p'; 'p_dot' ;'e_dot' ; 'gamma' ; 'zeta'}, ...
    'InputName', {'V_s';'V_d'}, 'OutputName', {'p';'e_dot'});

%Aggressive tuning
Q_PI = diag([100 30 100 20 50]);
R_PI = diag([0.1 1]);
K_PI = lqr(A_PI,B_PI,Q_PI,R_PI);

K_P_PI = K_PI(1:2,1:3);
P_PI = inv(C*inv(B*K_P_PI-A)*B);
%

    
%% *---------------- PART IV - State Estimation -------------------------*

%% |-- Task 5.4.1 - Math for observer --|
A_L = [0 1 0 0 0 0; 0 0 0 0 0 0; 0 0 0 1 0 0; 0 0 0 0 0 0; 0 0 0 0 0 1; K_3 0 0 0 0 0];
B_L = [0 0; 0 K_1; 0 0; K_2 0; 0 0; 0 0];
C_L = [1 0 0 0 0 0; 0 0 1 0 0 0; 0 0 0 0 1 0];
D_L = 0;
SYS_L = ss(A_L, B_L, C_L, D_L, ... 
    'StateName',{'p'; 'p_dot' ; 'e'; 'e_dot' ; 'h' ; 'h_dot'}, ...
    'InputName', {'V_s';'V_d'}, 'OutputName', {'p';'e';'h'});
%

%% |-- Task 5.4.2 - Closed-Loop Observer --|
Q_L = diag([30 30 100 20 60]);
R_L = diag([1 1]);
K_L = lqr(A_PI,B_PI,Q_L,R_L);

K_P_L = K_L(1:2,1:3);
P_L = inv(C*inv(B*K_P_L-A)*B);

system_poles = eig(A_PI-B_PI*K_L);

r0 = max(abs(system_poles));

fr = 15;
phi = pi/8;
r = r0*fr;

spread = -phi:(phi/(2.5)):phi;

p=-r*exp(1i*spread);

figure(3)
plot(real(system_poles),imag(system_poles),'sb',real(p),imag(p),'rx');
grid on; axis equal

L = transpose(place(transpose(A_L),transpose(C_L),p));
% 

%% |-- Task 5.4.3 - Bad Closed-Loop Observer --|
%Reduce integral effect and make power less available 
Q_B_L = diag([5 3 50 0.01 0.01]);
R_B_L = diag([500 500]);
K_B_L = lqr(A_PI,B_PI,Q_L,R_L);

C_B_L = [0 0 1 0 0 0; 0 0 0 0 1 0];

K_P_B_L = K_L(1:2,1:3);
P_B_L = inv(C*inv(B*K_P_L-A)*B);

system_poles_B = eig(A_PI-B_PI*K_L);

%Attempt to keep poles faster than system, but slower than noise
p_B = -[1.5 2 2.5 3 3.5 4];
figure(4)
plot(real(system_poles_B),imag(system_poles_B),'sb',real(p),imag(p),'rx');
grid on; axis equal

B_L = transpose(place(transpose(A_L),transpose(C_B_L),p_B));
%
