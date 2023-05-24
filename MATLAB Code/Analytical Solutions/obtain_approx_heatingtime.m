% ==============================================================================
% This is a function calculating the approximate heating time.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_approx_heatingtime(t, input)

[~, Tapprox] = obtain_approx_sol_heating(t, input);
outputs = Tapprox(1)-input.Tm;

return