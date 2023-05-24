% ==============================================================================
% This is a top-level routine.
% Freeze-drying Problem
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================
close all; clear; clc;

%% Pre-simulation
% Add paths
addpath('Plot Functions', 'Input Data', 'Analytical Solutions', ...
    'Numerical Solutions', 'Events')

% Extract the required input data
input = get_input_data;
N = input.N;
position = input.x;
dt = input.dt;
endtime = input.endtime_d;
tmax = input.tmax/3600;

% Extract some important matrices
A_FDM = obtain_Jacobian_FDM(input);
A_FEM = obtain_Jacobian_FEM(input);
M_FDM = obtain_MassMatrix_FDM(input);
M_FEM = obtain_MassMatrix_FEM(input);
M_sub = [1, 0 ; 0, 0];
CN_FDM = cond(A_FDM); 
CN_FEM = cond(A_FEM);  
optNLP = optimoptions('fsolve','StepTolerance', 1e-10, ...
    'OptimalityTolerance', 1e-10, 'FunctionTolerance', 1e-10, ...
    'MaxFunctionEvaluations', 3000, 'MaxIterations', 3000);

% Option selection
Mode = input.mode;  % microwave mode
load_data = 'off';  % load previous simulation data
FDM = 'on';  % finite difference solution
FEM = 'on';  % finite element solution
Exact = 'on';  % exact solution
Approx = 'on';  % approximate solution
Plot_temp = 'on';  % temperature profile plot for the heating stage
Plot_shelf = 'on';  % shelf temperature profile plot
Plot_interface = 'on';  % interface profile plot
Exact_analysis = 'off';  % analyze the exact solution
Approx_analysis = 'off';  % analyze the approximate solution, turn load_data on
Numerical_analysis = 'off';  % compare with the numerical solution

%% Load previous data
switch load_data
case 'on'
location = 'Simulation Results';
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

end

%% Solution techniques
switch FDM
case 'on'
[t_FDM, t_FDM2, y_FDM, y_FDM2] = obtain_FDM_sol(input);
[time_FDM, Temp_FDM, Tshelf_FDM, tm_FDM] = temperature_postprocessing(t_FDM, y_FDM, input);
[time_FDM2, itf_FDM, Tshelf_FDM2, tdry_FDM] = interface_postprocessing(t_FDM2, y_FDM2, input);
switch Plot_temp; case 'on'; figure; plot_temp_waterfall(position, time_FDM, Temp_FDM) ; title('Spatiotemporal temperature (FDM)'); end
switch Plot_shelf; case 'on'; figure; plot_Tshelf([time_FDM; time_FDM2], [Tshelf_FDM; Tshelf_FDM2]); end
switch Plot_interface; case 'on'; figure; plot_interface(time_FDM2, itf_FDM); end 
end

switch FEM
case 'on'
[t_FEM, t_FEM2, y_FEM, y_FEM2] = obtain_FEM_sol(input);
[time_FEM, Temp_FEM, Tshelf_FEM, tm_FEM] = temperature_postprocessing(t_FEM, y_FEM, input);
[time_FEM2, itf_FEM, Tshelf_FEM2, tdry_FEM] = interface_postprocessing(t_FEM2, y_FEM2, input);
switch Plot_temp; case 'on'; figure; plot_temp_waterfall(position, time_FEM, Temp_FEM) ; title('Spatiotemporal temperature (FEM)'); end
switch Plot_shelf; case 'on'; figure; plot_Tshelf([time_FEM; time_FEM2], [Tshelf_FEM; Tshelf_FEM2]); end
switch Plot_interface; case 'on'; figure; plot_interface(time_FEM2, itf_FEM); end
end

switch Exact
case 'on'  
switch Mode
case {'CFD','HFD'}
[tm_exact, fval1] = fsolve(@(t) obtain_exact_heatingtime(t,input), 0);
[time_exact, Temp_exact] = obtain_exact_sol_heating([(0:input.time_dim(dt)/3600:tm_exact).';tm_exact], input);
case 'MFD'
[tm_exact, fval1] = fsolve(@(t) obtain_exact_heatingtime_MFD(t,input), 0);
[time_exact, Temp_exact] = obtain_exact_sol_heating_MFD([(0:input.time_dim(dt)/3600:tm_exact).';tm_exact], input);
end
switch Plot_temp; case 'on'; figure; plot_temp_waterfall(position, time_exact, Temp_exact) ; title('Spatiotemporal temperature (Exact)'); end
[tdry_exact, fval2] = fsolve(@(t) obtain_exact_sublimationtime(t,tm_exact,input), tm_exact);  % final time
[time_exact2, itf_exact] = obtain_exact_sol_sublimation(tdry_exact, tm_exact, input);
switch Plot_interface; case 'on'; figure; plot_interface(time_exact2, itf_exact); end
end

switch Approx
case 'on'
switch Mode
case {'CFD','HFD'}
[tm_approx, fval3] = fsolve(@(t) obtain_approx_heatingtime(t,input), 1);
[time_approx, Temp_approx] = obtain_approx_sol_heating([(0:input.time_dim(dt)/3600:tm_approx).';tm_approx], input);
case 'MFD'
[tm_approx, fval3] = fsolve(@(t) obtain_exact_heatingtime_MFD(t,input), 0);
[time_approx, Temp_approx] = obtain_exact_sol_heating_MFD([(0:input.time_dim(dt)/3600:tm_approx).';tm_approx], input);
end
switch Plot_temp; case 'on'; figure; plot_temp_waterfall(position, time_approx, Temp_approx) ; title('Spatiotemporal temperature (Approx)'); end
[tdry_approx, fval4] = fsolve(@(t) obtain_exact_sublimationtime(t,tm_approx,input), tm_approx);  % final time
[time_approx2, itf_approx] = obtain_exact_sol_sublimation(tdry_approx, tm_approx, input);
switch Plot_interface; case 'on'; figure; plot_interface(time_approx2, itf_approx); end
end


%% Exact solution analysis
switch Exact_analysis
case 'on'

% Exact solution
figure
exact_fig = tiledlayout(1,2,'TileSpacing','loose','Padding','compact');
set(gcf, 'units', 'centimeters', 'Position',  [0, 0, 18, 8]);
nexttile; plot_temp_waterfall(position, time_exact, Temp_exact); text(-0.16,1.005,'(a)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
nexttile; plot_interface(time_exact2, itf_exact); text(-0.17,1.005,'(b)','Units','normalized','FontSize', 10 ,'fontweight', 'bold'); set(gca,'fontsize',8);

% Series analysis
[time, term1, term2] = exact_series_analysis(time_exact, input);
for i = 1:length(time)
    term_analysis1(i,1:input.nterm) = abs(term1(i,N,:));
    term_analysis2(i,1:input.nterm) = abs(term2(i,N,:));
end

figure
series_fig = tiledlayout(1,2,'TileSpacing','loose','Padding','compact');
set(gcf, 'units', 'centimeters', 'Position',  [0, 0, 18, 8]);
nexttile; plot_series(term_analysis1,time_exact,input); text(-0.16,.995,'(a)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); 
ylabel('$$K_{3,n}e^{-\beta_n^2\tau}cos\beta_n\xi$$', 'Interpreter', 'LaTeX'); set(gca,'fontsize',8);
nexttile; plot_series(term_analysis2,time_exact,input); text(-0.16,.995,'(b)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
ylabel('$$\frac{e^{-\beta_n^2\tau}cos\beta_n\xi}{\beta_n^2cos\beta_n(\nu^2+\nu+\beta_n^2)}$$', 'Interpreter', 'LaTeX'); set(gca,'fontsize',8);
text(-0.3,1.04,'-','Units','normalized','FontSize', 10 ,'color','w')

% One-term solution
[time_oneterm, Temp_oneterm] = obtain_exact_oneterm_heating([(0:input.time_dim(dt)/3600:tm_exact).';tm_exact], input);
oneterm_fig = figure;  plot_oneterm_exact_heating(time, Temp_exact, Temp_oneterm, input);
set(gcf, 'units', 'centimeters', 'Position',  [0, 0, 9, 8]); set(gca,'fontsize',8);
text(-0.1,1.04,'-','Units','normalized','FontSize', 10 ,'color','w')

end

%% Approximate solution analysis
switch Approx_analysis
case 'on'
figure
approx_fig = tiledlayout(1,2,'TileSpacing','loose','Padding','compact');
set(gcf, 'units', 'centimeters', 'Position',  [0, 0, 18, 8]);
nexttile; plot_temp_waterfall(position, time_approx_CFD, Temp_approx_CFD); text(-0.16,.95,'(a)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
nexttile; plot_temp_waterfall(position, time_approx_HFD, Temp_approx_HFD); text(-0.16,.95,'(b)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);

figure
approx_exact_fig = tiledlayout(1,2,'TileSpacing','loose','Padding','compact');
set(gcf, 'units', 'centimeters', 'Position',  [0, 0, 18, 8]);
nexttile; plot_exact_approx_heating(time_exact_CFD(1:end-1), Temp_exact_CFD(:,1:end-1), Temp_approx_CFD(:,1:end-1), input); text(-0.17,1.005,'(a)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
nexttile; plot_exact_approx_heating(time_exact_HFD(1:end-1), Temp_exact_HFD(:,1:end-1), Temp_approx_HFD(:,1:end-1), input); text(-0.17,1.005,'(b)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
text(-0.3,1.04,'-','Units','normalized','FontSize', 10 ,'color','w')

end

%% Numerical solution analysis
switch Numerical_analysis
case 'on'

figure
numer_exact_fig = tiledlayout(1,2,'TileSpacing','loose','Padding','compact');
set(gcf, 'units', 'centimeters', 'Position',  [0, 0, 18, 8]);
nexttile; plot_exact_numerical_heating(time_exact(1:end-1), Temp_exact(:,1:end-1), Temp_FDM(:,1:end-1), Temp_FEM(:,1:end-1), input); text(-0.16,1.005,'(a)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
nexttile; plot_exact_numerical_heating_normalscale(time_approx(1:end-1), Temp_approx(:,1:end-1), Temp_FDM(:,1:end-1), Temp_FEM(:,1:end-1), input); text(-0.18,1.005,'(b)','Units','normalized','FontSize', 10 ,'fontweight', 'bold' ); set(gca,'fontsize',8);
text(-0.3,1.03,'-','Units','normalized','FontSize', 10 ,'color','w')

end
