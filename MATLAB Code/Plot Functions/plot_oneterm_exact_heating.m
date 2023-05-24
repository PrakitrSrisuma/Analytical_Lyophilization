% ==============================================================================
% This is a function creating the plots for oneterm-exact solution
% comparison during the heating stage.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_oneterm_exact_heating(time, Temp_exact, Temp_oneterm, input)

% Parameters
N = input.N;
ntime = length(time);

% Vector of errors
e_L2 = zeros(ntime,1);
e_Linf = zeros(ntime,1);

for i = 1:ntime
    e_L2(i) = sqrt(1/N)*(norm(Temp_oneterm(i,:)-Temp_exact(i,:),2));
    e_Linf(i) = norm(Temp_oneterm(i,:)-Temp_exact(i,:),inf);

end

% semilogy(time,e_L2,'-.b','linewidth',2)
% hold on 
semilogy(time,e_Linf,'-b','linewidth',2)
hold on
xlabel('Time (hours)')
% ylabel('Error in the{\it p}-norm (K)')
ylabel('Error measured using the \infty-norm (K)')
xlim([0 time(end)])
%legend('{\it p} = 2', '{\it p} = \infty','location','best')

return