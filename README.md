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

We were pleased with the outcome of the term project, and feel that we've gained a good understanding of several control principles for linear systems. It was a demanding task that required quite a few hours to complete. 

## Boat lab
_we haven't started yet, will update_
