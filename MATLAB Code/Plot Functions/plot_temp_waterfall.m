% ==============================================================================
% This is a function creating the waterfall plots.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_temp_waterfall(position, time, Temp)

pos = position*100;
surf(pos, time, Temp,'linewidth',2,'FaceColor','white','EdgeColor','interp','MeshStyle','row')
xlabel('Position (cm)')
ylabel('Time (hours)')
zlabel('Temperature (K)')
xticks((0:1:pos(end)))
yticks((0:0.1:time(end)))
zlim([230 270])

return