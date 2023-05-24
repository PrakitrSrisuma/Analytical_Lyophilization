% ==============================================================================
% This is a function creating the plots for approximate solutions during 
% the heating stage.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_approx_CFD_HFD(input)

% Parameters
N = input.N;
position = input.x;
location = 'C:\Users\pkta1\OneDrive - Chulalongkorn University\Academic\MIT\PhD_CSE\Research\FreezeDrying\MATLAB\FreezeDrying Rev.1\Data';
Temp_exact_HFD = load(fullfile(location,  'Temp_exact_HFD.mat')).Temp_exact;
time_exact_HFD = load(fullfile(location,  'time_exact_HFD.mat')).time_exact;
Temp_approx_HFD = load(fullfile(location,  'Temp_approx_HFD.mat')).Temp_approx;
time_approx_HFD = load(fullfile(location,  'time_approx_HFD.mat')).time_approx;
Temp_oneterm_HFD = load(fullfile(location,  'Temp_oneterm_HFD.mat')).Temp_oneterm;
Temp_exact_CFD = load(fullfile(location,  'Temp_exact_CFD.mat')).Temp_exact;
time_exact_CFD = load(fullfile(location,  'time_exact_CFD.mat')).time_exact;
Temp_approx_CFD = load(fullfile(location,  'Temp_approx_CFD.mat')).Temp_approx;
time_approx_CFD = load(fullfile(location,  'time_approx_CFD.mat')).time_approx;
Temp_oneterm_CFD = load(fullfile(location,  'Temp_oneterm_CFD.mat')).Temp_oneterm;



approx_fig = tiledlayout(1,2,'TileSpacing','loose','Padding','compact');
set(gcf, 'units', 'centimeters', 'Position',  [0, 0, 18, 8]);
nexttile; plot_temp_waterfall(position, time_approx_CFD, Temp_approx_CFD); text(-0.16,1.005,'(a)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
nexttile; plot_temp_waterfall(position, time_approx_HFD, Temp_approx_HFD); text(-0.16,1.005,'(b)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
filename = fullfile('C:\Users\pkta1\OneDrive - Chulalongkorn University\Academic\MIT\PhD_CSE\Research\FreezeDrying\Figure',  'Approx_solution.pdf');
exportgraphics(approx_fig, filename,'Resolution',1000)

return