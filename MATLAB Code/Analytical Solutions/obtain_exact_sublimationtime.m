% ==============================================================================
% This is a function calculating the exact sublimation time.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_exact_sublimationtime(t, tm, input)

% Exact solution
[~, itf] = obtain_exact_sol_sublimation(t, tm, input);
outputs  = itf(end)-input.L;

return