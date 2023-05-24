% ==============================================================================
% This is a function creating the exact solution for MFD during heating.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function [output1, output2] = obtain_exact_sol_heating_MFD(tspan, input)

% Parameters
position = input.x;
tspan = tspan*3600;  % convert hours to seconds

Texact = zeros(length(tspan),length(position));
for i = 1:length(tspan)
    Texact(i,:) = input.T0_d + input.lambda1*input.time_non(tspan(i));
end

output1 = tspan/3600;
output2 = input.temp_dim(Texact);

return