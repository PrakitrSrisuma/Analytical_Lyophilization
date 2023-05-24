% ==============================================================================
% This is a function creating the system of ODEs based on the linear finite
% element method (FEM) for the ODE solver during the heating period.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_ODEs_FEM(t,y,A,input)

% Extract some important input data
N = input.N;
dx = input.dx;
Ta_d = input.Ta_d;
Bia = input.Bia;
Bib = input.Bib;
lambda = input.lambda1;
Tshelf = input.Tshelf(input.time_dim(t));
Tshelf_d = input.temp_non(Tshelf);

% Create a RHS vector
RHS = lambda*dx*ones(N,1);
RHS(1) = RHS(1)/2;
RHS(N) = RHS(N)/2;
RHS(1) = RHS(1) + Bia*Ta_d;
RHS(N) = RHS(N) + Bib*Tshelf_d;

% Create a system of ODE
dydt = A*y(1:end-1) + RHS;
outputs = [dydt; y(end)-Tshelf_d];

return