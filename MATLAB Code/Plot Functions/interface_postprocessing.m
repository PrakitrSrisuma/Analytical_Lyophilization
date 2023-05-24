% ==============================================================================
% This is a function processing the moving interface profile.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function [output1, output2, output3, output4] = interface_postprocessing(time_d, s_d, input)

% Process the data
Tshelf_d = s_d(:,end);  % shelf temperature (dimensionless)
Tshelf = input.temp_dim(Tshelf_d);  % shelf temperature (K)
s = input.pos_dim(s_d(:,1));  % actual temperature (K)
time = input.time_dim(time_d)/3600;  % actual time (hours)
tsub = time(end);  % time sublimation starts (hours)

% Export
output1 = time;
output2 = s;
output3 = Tshelf;
output4 = tsub;

return