% ==============================================================================
% This is a function creating the bottom temperature plot.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_Tbottom(time, Tb)

plot(time, Tb, 'linewidth',2)
xlabel('Time (hours)')
ylabel('Bottom temperature (K)')

return