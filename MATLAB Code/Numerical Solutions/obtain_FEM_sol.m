% ==============================================================================
% This is a function creating the FEM solution.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function [output1, output2, output3, output4] = obtain_FEM_sol(input)

% Parameters
N = input.N;  % number of nodes
endtime = input.endtime_d;  % final time
dt = 0.05;  % data collection frequency from the ODE solver
Tini_d = [input.T0_d*ones(N,1); input.Tb0_d];  % initial condition, shelf temperaute at the last position
tspan = (0:dt:endtime)';  % define the time span

% Extract the relevant matrices 
A_FEM = obtain_Jacobian_FEM(input);
M_FEM = obtain_MassMatrix_FEM(input);
M_sub = [1, 0 ; 0, 0]; 
CN_FEM = cond(A_FEM);  

% Solve the system of ODEs using FEM // stage 1: increasing temperature
options_FEM = odeset('Event', @(t_FEM,y_FEM) event_sublimation_starts(t_FEM,y_FEM,input), 'Mass', M_FEM, 'RelTol', 1e-6, 'AbsTol', 1e-6);
[t_FEM,y_FEM] = ode15s(@(t_FEM,y_FEM) obtain_ODEs_FEM(t_FEM,y_FEM,A_FEM,input), tspan, Tini_d, options_FEM);

% Solve the system of ODEs using FEM // stage 2: sublimation
s0_FEM = [input.s0_d; input.Tshelf_d(t_FEM(end))];
options_sub = odeset('Event', @(t_FEM2,y_FEM2) event_sublimation_completes(t_FEM2,y_FEM2,input),'Mass', M_sub, 'RelTol', 1e-6, 'AbsTol', 1e-6);
[t_FEM2,y_FEM2] = ode15s(@(t_FEM2,y_FEM2) obtain_ODE_sublimation(t_FEM2,y_FEM2,input), (t_FEM(end):dt:2*endtime)', s0_FEM, options_sub); 

% Export
output1 = t_FEM;
output2 = t_FEM2;
output3 = y_FEM;
output4 = y_FEM2;

return