% ==============================================================================
% This is a function calculating the exact heating time for MFD.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_exact_heatingtime_MFD(t, input)

[~, Temp_exact] = obtain_exact_sol_heating_MFD(t, input);
outputs = Temp_exact(end)-input.Tm;

return