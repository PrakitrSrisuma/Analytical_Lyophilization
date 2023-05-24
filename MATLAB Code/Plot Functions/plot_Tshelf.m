% ==============================================================================
% This is a function creating the shelf temperature plot.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_Tshelf(time, Tshelf)

plot(time, Tshelf, 'linewidth',2)
xlabel('Time (hours)')
ylabel('Shelf temperature (K)')

return