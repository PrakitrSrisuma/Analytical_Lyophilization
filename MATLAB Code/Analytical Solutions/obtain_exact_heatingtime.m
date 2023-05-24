% ==============================================================================
% This is a function calculating the exact heating time.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_exact_heatingtime(t, input)

[~, Temp_exact] = obtain_exact_sol_heating(t, input);
outputs = Temp_exact(1)-input.Tm;

return