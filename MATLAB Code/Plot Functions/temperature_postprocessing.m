% ==============================================================================
% This is a function processing the temperature profile.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function [output1, output2, output3, output4] = temperature_postprocessing(time_d, Temp_d, input)

% Process the data
Tshelf_d = Temp_d(:,end);  % shelf temperature (dimensionless)
Tshelf = input.temp_dim(Tshelf_d);  % shelf temperature (K)
Temp = input.temp_dim(Temp_d(:,1:end-1));  % actual temperature (K)
time = input.time_dim(time_d)/3600;  % actual time (hours)
tm = time(end);  % time sublimation starts (hours)

% Export
output1 = time;
output2 = Temp;
output3 = Tshelf;
output4 = tm;

return