% ==============================================================================
% This is a function creating the exact solution for the heating period.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function [output1, output2, output3] = exact_series_analysis(tspan, input)

% Parameters
Bib = input.Bib;
L = input.L;
sigma = input.sigma;
lam = input.lambda1;
position = input.x;
tspan = tspan*3600;  % convert hours to seconds
time_non = input.time_non;
temp_dim = input.temp_dim;
pos_non = input.pos_non;
nterm = input.nterm;
root = input.root;

% Prepare the matrices
An = zeros(nterm,1);
An2 = zeros(nterm,1);

% Coefficients
for i = 1:nterm
    An(i) = ((lam/(2*root(i)))*sin(root(i)) + (lam/(root(i)^2))*cos(root(i)) - (lam/(root(i)^3))*sin(root(i)) + sin(root(i))*input.T0_d/root(i) - (sin(root(i))/root(i))*(lam*(1/Bib+1/2)))/(0.5+sin(root(i))*cos(root(i))/(2*root(i)));
end

% Coefficients
for i = 1:nterm
    An2(i) = 1/(root(i)^2*((Bib^2+root(i)^2)+Bib)*cos(root(i)));
end

% Calculate the exact solution 1
Term1 = zeros(length(tspan),length(position),nterm);
for i = 1:length(tspan)
    for j = 1:length(position)
        for k = 1:nterm
            Term1(i,j,k) = (exp(-root(k)^2*time_non(tspan(i)))*An(k)*cos(root(k)*pos_non(position(j)))); 
        end
    end
end

% Calculate the exact solution 2
Term2 = zeros(length(tspan),length(position),nterm);
for i = 1:length(tspan)
    for j = 1:length(position)
        for k = 1:nterm
            Term2(i,j,k) = (exp(-root(k)^2*time_non(tspan(i))))*An2(k)*cos(root(k)*pos_non(position(j))); 
        end
    end
end

% Superposition and export
output1 = tspan/3600;
output2 = Term1;
output3 = Term2;

return