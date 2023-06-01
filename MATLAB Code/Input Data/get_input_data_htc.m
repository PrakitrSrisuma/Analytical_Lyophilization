% ==============================================================================
% This is a function creating and defining all inputs.
% Freeze-drying Problem
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = get_input_data_htc(hb)

%% Parameters/Variables
input.mode = 'CFD';  % choose between 'HFD', 'CFD', 'MFD'
input.rhoa = 63;  % density of dried layer (kg/m3)
input.rhof = 917;  % density of the frozen region (kg/m3)
input.Cpf = 1967.8;  % heat capacity of the frozen region (J/kgK)
input.kf = 2.30;  % thermal conductivity of the frozen region (kg/m3)
input.alpf = input.kf/(input.rhof*input.Cpf);  % thermal diffusivity (m2/s)
input.dHsub = 2.84e6;  % enthalpy of sublimation (J/kg)
input.Hw = 242345;  % microwave irradiation, default 242345
input.ha = 0;  % heat transfer coefficient at the bottom surface (W/m2K)
input.hb = hb;  % heat transfer coefficient at the top surface (W/m2K), default 65
input.pbw = 0.04;
input.pw = 0.92;
input.pice = 1-input.pbw;
input.L = 7.15e-3;  % length/height of the microwave (m)
input.Tmax = 268.15;  % maximum shelf temperature (K), default 281.85
input.Tb0 = 228.15;  % initial shelf temperature (K), default 236.85
input.Tb0 = min(input.Tmax,input.Tb0);
input.T0 = 228.15;  % initial temperature (K), default 236.85
input.Tm = 256.15;  % sublimation temperature (K)
input.Ta = 298.15;  % ambient temperature (K)
input.s0 = 0;  % length/height of the frozen area (m)
input.r = 0.25/60;  % shelf temperature ramp-up rate (K/s), default 1/60
input.tmax = max((input.Tmax-input.Tb0)/input.r, 0);  % time that the heater temperature reaches its maximum value (s)
input.endtime = 1e5;  % final time (s) 

switch input.mode
case 'MFD'
input.hb = 0;
case 'CFD'
input.Hw = 0;
end

% Microwave power
input.Hv1 = input.Hw*input.pbw;
input.Hv2 = input.Hw*input.pw;

%% Define functions
% non = nondimensionalize, dim = convert back to actual unit
input.temp_non = @(x) (x-input.Tb0)/(input.Tm-input.Tb0);
input.temp_dim = @(x) x*(input.Tm-input.Tb0)+input.Tb0;
input.temp_non2 = @(x) (x-input.Tmax)/(input.Tm-input.Tmax);
input.temp_dim2 = @(x) x*(input.Tm-input.Tmax)+input.Tmax;
input.pos_non = @(x) x/input.L;
input.pos_dim = @(x) x*input.L;
input.time_non = @(x) x*input.alpf/input.L^2;
input.time_dim = @(x) x*input.L^2/input.alpf;
input.irad_non = @(x) x*input.L^2/(input.kf*(input.Tm-input.Tb0));  % irradiation term
input.irad_dim = @(x) x*(input.kf*(input.Tm-input.Tb0))/input.L^2;
input.htc_non = @(x) x*input.L/input.kf;  % heat transfer coefficient or Biot number
input.htc_dim = @(x) x*input.kf/input.L;
input.shelf_non = @(x) x*input.L^2/(input.alpf*(input.Tm-input.Tb0));  % shelf heating rate
input.shelf_dim = @(x) x*(input.alpf*(input.Tm-input.Tb0))/(input.L^2);
input.sub_dim = @(x,y,z) input.L*(x+y+z*input.L)/(input.alpf*input.dHsub*input.pice*(input.rhof-input.rhoa));  % sublimation term
input.Tshelf = @(x) min([input.Tb0+input.r*x input.Tmax]);  %  shelf temperature (K)
input.Tshelf_d = @(x) min([input.shelf_non(input.r)*x input.temp_non(input.Tmax)]);  %  shelf temperature (dimensionless)
 
%% Nondimensionalization
input.Tb0_d = input.temp_non(input.Tb0);
input.T0_d = input.temp_non(input.T0);
input.Tm_d = input.temp_non(input.Tm);
input.Ta_d = input.temp_non(input.Ta);
input.Tmax_d = input.temp_non(input.Tmax);
input.s0_d = input.pos_non(input.s0);
input.endtime_d = input.time_non(input.endtime);
input.tmax_d = input.time_non(input.tmax);
input.Bia = input.htc_non(input.ha); 
input.Bib = input.htc_non(input.hb);  % Biot number, nu in the manuscript
input.sigma = input.shelf_non(input.r);
input.lambda1 = input.irad_non(input.Hw*input.pbw);
input.lambda2 = input.irad_non(input.Hw*input.pw);
input.kappa1 = (input.L^3*input.r*input.hb)/(input.alpf^2*input.dHsub*input.pice*(input.rhof-input.rhoa));
input.kappa2 = (input.L*(input.Tb0*input.hb - input.Tm*input.hb + input.Hw*input.pw*input.L))/(input.alpf*input.dHsub*input.pice*(input.rhof-input.rhoa));

%% Discretization
input.N = 20;  % number of nodes
input.dx = 1/(input.N-1);
input.x_d = (input.s0_d:input.dx:1)';
input.x = input.pos_dim(input.x_d);
input.dt = 1;

%% Exact solution
input.nterm = 0;  % number of terms in the infinite series
input.root = zeros(input.nterm,1);
for i = 1:input.nterm
    u = fmincon(@(u) (input.Bib*cos(u)-u*sin(u))^2, (i-1)*pi, [], [], [], [], (i-1)*pi, i*pi);
    input.root(i,1) = u;
end

%% Approximate solution
input.c1 = 3*input.Bib/(2*input.Bib+6);
input.c2 = (input.lambda1 - input.sigma)/2;
input.c3 = 1+2/input.Bib;

%% Export
outputs = input;

return
