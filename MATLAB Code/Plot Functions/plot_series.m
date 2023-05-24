% ==============================================================================
% This is a function analyzing the infinite series.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function plot_series(value, time, input)

n = 10;
term = (1:1:n)';
time = input.time_non(time*3600);
index = [1, 5, 9, 13];
markertype = {'-o', '-x', '-diamond', '-*'};

for i = 1:length(index)
    semilogy(term, value(index(i),1:n),markertype{i},'linewidth',1,'markersize',6,'DisplayName',['\tau = ', num2str(time(index(i)))])
    hold on
end
xlabel('\it{n}')
xticks(0:1:10)
%ylabel('$$K_ne^{n}$$', 'Interpreter', 'LaTeX')
ylim([1e-16 1])
legend('location','best')

return