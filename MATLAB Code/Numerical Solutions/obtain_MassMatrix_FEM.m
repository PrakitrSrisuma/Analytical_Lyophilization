% ==============================================================================
% This is a function creating the mass matrix based on the linear finite element
% method (FEM) for the time derivatives in the ODEs.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_MassMatrix_FEM(input)

% Extract some important input data
N = input.N;
dx = input.dx;

% Create the mass matrix and export
M = diag((2/3)*ones(N,1),0) + diag((1/6)*ones(N-1,1),1) + diag((1/6)*ones(N-1,1),-1);
M(1,1) = 1/3;  M(N,N) = 1/3;
M = dx*M;

% Add a dimension for collecting the shelf temperature
M = [M, zeros(N,1)];
M = [M; zeros(1,N+1)];

% Export
outputs = M;

return