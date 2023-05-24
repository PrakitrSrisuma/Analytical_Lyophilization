% ==============================================================================
% This is a function creating the ODE for the sublimation stage.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = obtain_ODE_sublimation(t,y,input)

% Parameters
ha = input.ha;
hb = input.hb;
Tm = input.Tm;
Ta = input.Ta;
Tshelf = input.Tshelf(input.time_dim(t));
Tshelf_d = input.temp_non(Tshelf);

% Create the ODE for sublimation
Ha = ha*(Ta-Tm);
Hb = hb*(Tshelf-Tm);
Hv = input.Hv2;
kappa = input.sub_dim(Ha, Hb, Hv);
dsdt = kappa;

outputs = [dsdt; y(end)-Tshelf_d];

return