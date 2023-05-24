% ==============================================================================
% This is a function creating the plots for numerical-exact solution
% comparison during the heating stage.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_exact_numerical_heating(time, Temp_exact, Temp_FDM, Temp_FEM, input)

% Parameters
N = input.N;
ntime = length(time);

% Vector of errors
e_L2_FDM = zeros(ntime,1);
e_Linf_FDM = zeros(ntime,1);
e_L2_FEM = zeros(ntime,1);
e_Linf_FEM = zeros(ntime,1);

for i = 1:ntime
    e_L2_FDM(i) = sqrt(1/N)*(norm(Temp_FDM(i,:)-Temp_exact(i,:),2));
    e_Linf_FDM(i) = norm(Temp_FDM(i,:)-Temp_exact(i,:),inf);
    e_L2_FEM(i) = sqrt(1/N)*(norm(Temp_FEM(i,:)-Temp_exact(i,:),2));
    e_Linf_FEM(i) = norm(Temp_FEM(i,:)-Temp_exact(i,:),inf);
end

plot(time,e_Linf_FDM,'-rx','linewidth',1)
hold on
plot(time,e_Linf_FEM,'-b','linewidth',2)
hold on
xlabel('Time (hours)')
ylabel('Error measured using the \infty-norm (K)')
xlim([0 time(end)])
legend('FDM', 'FEM', 'location', 'best')

return