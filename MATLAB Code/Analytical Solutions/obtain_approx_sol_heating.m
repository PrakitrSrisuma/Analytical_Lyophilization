% ==============================================================================
% This is a function calculating the approximate solution.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function [output1, output2] = obtain_approx_sol_heating(tspan, input)

% Parameters
T0_d = input.T0_d;
sigma = input.sigma;
time_non = input.time_non;
temp_dim = input.temp_dim;
pos_non = input.pos_non;
tspan = tspan*3600;  % convert hours to seconds
position = input.x;
c1 = input.c1;
c2 = input.c2;
c3 = input.c3;

% Approximate solution
Tapprox = zeros(length(tspan),length(position));
for i = 1:length(tspan)
    a3 = (c2-c1*T0_d)*exp(-2*c1*time_non(tspan(i))) - c2;
    a1 = sigma*time_non(tspan(i))-a3*c3;
    Tapprox(i,:) = a1 + a3*pos_non(position).^2;
end

Tapprox = temp_dim(Tapprox);
output1 = tspan/3600;
output2 = Tapprox;

return