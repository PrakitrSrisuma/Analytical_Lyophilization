% ==============================================================================
% This is a function creating the exact solution to the sublimation model.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function [output1, output2] = obtain_exact_sol_sublimation_end(tfinal, tm, input)

% Parameters
kappa1 = input.kappa1;
kappa2 = input.kappa2;
s0_d = input.s0_d;
tmax_d = input.tmax_d;
dt = input.dt;
tm = input.time_non(tm*3600);
tfinal = input.time_non(tfinal*3600);

% Calculate the required inputs
tspan = [(tm:dt:tfinal).'; tfinal];  % time domain
s_d = zeros(length(tspan),1);
if tmax_d >= tm
    s_mid = s0_d + kappa1*(tmax_d^2-tm^2)/2 + kappa2*(tmax_d-tm);  % interface position at the maximum shelf temperature
else
    s_mid = 0;
end

% Exact solution
for i = 1:length(tspan)
    if tmax_d >= tm
        if tspan(i) < tmax_d
            s_d(i) = s0_d + kappa1*(tspan(i)^2-tm^2)/2 + kappa2*(tspan(i)-tm);
        else
            s_d(i) = s_mid + (kappa1*(tmax_d) + kappa2)*(tspan(i)-tmax_d);
        end
    else
        s_d(i) = s_mid + (kappa1*(tmax_d) + kappa2)*(tspan(i)-tm);
    end

    if s_d(i) >=1
        break
    end
end
s_d = s_d(1:i);
tspan = tspan(1:i);

output1 = input.time_dim(tspan)/3600;
output2 = input.pos_dim(s_d);

return