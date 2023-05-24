% ==============================================================================
% This is a function creating the plots for approximate-exact solution
% comparison during the heating stage.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_exact_approx_heating(time, Temp_exact, Temp_approx, input)

% Parameters
N = input.N;
ntime = length(time);

% Vector of errors
e_L2 = zeros(ntime,1);
e_Linf = zeros(ntime,1);

for i = 1:ntime
    e_L2(i) = sqrt(1/N)*(norm(Temp_approx(i,:)-Temp_exact(i,:),2));
    e_Linf(i) = norm(Temp_approx(i,:)-Temp_exact(i,:),inf);

end

plot(time,e_Linf,'-b','linewidth',2)
hold on
xlabel('Time (hours)')
ylabel('Error measured using the \infty-norm (K)')
xlim([0 time(end)])


return