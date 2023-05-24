% ==============================================================================
% This is a function creating the sublimating interface plot.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_interface(time, interface)

plot(time,interface*100,'linewidth',2,'color','r')
xlabel('Time (hours)')
ylabel('Interface position (cm)')

return