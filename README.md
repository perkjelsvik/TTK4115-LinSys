# [TTK4115 - Linear System Theory](http://www.ntnu.edu/studies/courses/TTK4115#tab=omEmnet)
**Course content:** Theory for linear multivariable systems, state space models, discretization, canonical forms and realizations, Lyapunov stability, controllability and observability, state feedback, LQR control, state estimation, the Kalman filter, descriptions of stochastic processes and random signals. 

In this course, we had two term projecs. I was in a group with two other students. The first project, the helicopter lab, counted 30% of the final grade, and the second project, the boat lab, counted 20%. Here's a brief description of the projects: 

## Helicopter lab
The project was divded into four parts:

* **PART I:** Mathematical Modeling
* **PART II:** Monovariable Control
* **PART III:** Multivariable Control
* **PART IV:** State Estimation

We used a quanser helicopter with 3 degrees of freedom [like this one](http://www.quanser.com/products/3dof_helicopter).
We were given an MATLAB code for initialization of the system, and a Simulink-model to start with. This made it possible for us to use the system right away and implement changes in MATLAB/Simulink as we wanted. For the first part, **part I**, we linearized our system. Here we laid out the foundation for the rest of the project. We also used a joystick without any controllers to control the helicopter. In **part II** we implemented a **PD**-controller for the pitch and a **P**-controller for travel rate. We were supplied with a **PID** controller for elevation. In **part III** we used a **LQR**-Controller for the system and **integral effect**. In the last part, **part IV**, we made an observer for our system and used this in conjucntion with the **LQR** and **integral effect** from the previous part. 

We were pleased with the outcome of the term project, and feel that we've gained a good understanding of several control principles for linear systems. It was a demanding task that required quite a few hours to complete. We achived 93/100 points on the lab.

## Boat lab
The project was divided into five parts:

* **PART I:** Identification of the Boat Parameters
* **PART II:** Identification of Wave Spectrum Model
* **PART III:** Control System Design
* **PART IV:** Observability
* **PART V:** Discrete Kalman Filter

We were given a SIMULINK file representing a cargo ship model, and a .mat-file acting as wave disturbance. For the first part, **part I**, we identified boat parameters by running the model in both smooth weather and roguh weather conditions. The paramters based on our measurments were then used for the rest of the assignment. In **part II** we estimated the power spectral density using MATLAB and were able to model the wave response. For **part III** we wanted to design an autopilot for the cargo ship. We did this by designing a **PD-Controller** and had the compass constraied to +- 35 deg. This is because the ship model only holds for small deviations in the compass value. The next part, **part IV**, we checked observability in the system as build-up to **part V**, where we implemented a **discrete Kalman filter** to estimate the rudder bias, the heading, and the high-frequency wave induced motion on the heading. This allowed us to use the Kalman filter for **wave filtering**. 

We were pleased with the end result, a complete SIMULINK-model and thorough report, and we feel that we've gained a good understanding of state estimation in control theory. It was a smaller project than the helicopter lab time-wise, but it was challenging work that still required a lot of work to complete. We achieved 96/100 points on the lab. 
