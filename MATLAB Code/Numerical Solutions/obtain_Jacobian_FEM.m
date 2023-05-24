% ==============================================================================
% This is a function creating the Jacobian based on the linear finite element
% method (FEM) for the system of ODEs.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_Jacobian_FEM(input)

% Extract some important input data
N = input.N;
dx = input.dx;
Bia = input.Bia;
Bib = input.Bib;

% Create a matrix
diagonal = -2*ones(N,1);
offdiag = ones(N-1,1);
A = diag(diagonal,0) + diag(offdiag,1) + diag(offdiag,-1);
A(1,1) = -1;  A(N,N) = -1;
A = (1/dx)*A;

% Stamp some boundary nodes
A(1,1) = A(1,1)-Bia;
A(N,N) = A(N,N)-Bib;


% Export
outputs = A;

return