
% Jan Havelka (jnhavelka@gmail.com)
% Copyright 2016, Czech Technical University in Prague
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% General setup
% mesh file for reality simulation
PROBLEM.General.MeshName = 'l_shape_real';
% mesh file for reconstruction/computation
PROBLEM.General.MeshName_comp = 'l_shape_comp';
% Name of output file
PROBLEM.General.SaveName = NameSequence('results_l_shape','output',[],'.mat',[]);
% SaveMode
PROBLEM.General.SaveMode = 1;
% keep statistics about solver etc
PROBLEM.General.Stats    = 1;
% presentation mode (no title in figures)
PROBLEM.General.PresentMode    = 0;

%% Video setup
PROBLEM.Video.Record=false;
PROBLEM.Video.Quality=100;
PROBLEM.Video.FrameRate=2;

%% Solver setup
% Accuracy of iterative solver (stop iterating if err is below accuracy)
PROBLEM.Solver.Accuracy = 5e-3;
% Maximum iteration steps of solver (stop iteration if iter exeeds NoI)
PROBLEM.Solver.NoI      = 40;
% % Regularisation coefficient (sigma)
% PROBLEM.Solver.lambda_s   = 1e-3;
% % Regularisation coefficient (capacity)
% PROBLEM.Solver.lambda_c   = 1e-3;

%% Time settings
% solve problem as stationary/time dependent
PROBLEM.TimeSettings.isStationary=false;
% time steps
ndays=7;
PROBLEM.TimeSettings.nT=ndays*24/2/2;
% time increment
PROBLEM.TimeSettings.dT=1800*2*2*2;
% time differentiation parameter <0;1>
PROBLEM.TimeSettings.Tau=0.75;
% type of capacity matrix: 'diagonal' or 'consistent' (nondiagonal)
PROBLEM.TimeSettings.Capacity='consistent';

%% MEASUREMENT ERROR
% sensor error [mean,standard deviation]
PROBLEM.Error.vars = [0,0.25/3];
% distribution type ('normal' or 'lognormal')
PROBLEM.Error.type = 'normal';
% sampling method 'lhs' or 'montecarlo'
PROBLEM.Error.sampling = 'lhs';
% number of samples
PROBLEM.Error.N_s = 5e2;

%% Measurements
PROBLEM.Measurements.delete_measurements={[0.0 0.99;0.0 0.61];...
                                     [0.61 0.0;0.99 0.0]};
% % omit measurements on sides
% PROBLEM.Measurements.delete_measurements={[0.0 0.99;0.0 0.61];...
%                                      [0.61 0.0;0.99 0.0];
%                                      % single sensor on inner left bnd
%                                      [0.00 0.6;0.3 0.6];
%                                      [0.40 0.6;0.6 0.6];
%                                      % single sensor on outer left boundary
% %                                      [0.20 1.0;1.0 1.0];
%                                      [0.10 1.0;1.0 1.0]};
% PROBLEM.Measurements.delete_measurements={[-0.00 0.99; -0.1 -0.1;0.99 0.0;0.9 0.9]};
% PROBLEM.Measurements.delete_measurements={[0.025 0.025; 0.025 1.025;1.025 1.025;1.025 0.025]};
% PROBLEM.Measurements.delete_measurements={};

%% Load definition
% definition of boundary conditions
% [N x 4] cell array of N boundary conditions
% BC{i,1} - [x1 y1;x2 y2] coordinates "from-to" where the BC apply
% BC{i,2} - BC type 'transfer'/'dirichlet'/'neumann'/'robin'
% BC{i,3} - prescribed value of BC. For each type:
%         - 'transfer' - defines a T0 in eq.: q=alpha*(T-T0)
%         - 'dirichlet' - sets the value of potential
%         - 'neumann' - sets the value of fluxes in [flux/m] - is then multiplied by length of element edge
% BC{i,4} - sets the additional information for each BC. For dirichlet/neumann leave the entry empty, i.e. [],
%           for 'transfer' it defines the transfer coefficient alpha
% The hierarchy is following: 'dirichlet' - 'neumann' - 'transfer', i.e. dirichlet overrides neumann etc.
PROBLEM.LoadDef.BC = {[0.0 0.6;0.6 0.6],'transfer',@(t) 20+0.1.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*5*ndays))-0.3.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays))-0.5.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t)),0.5e1;... inner left boundary
    [0.6 0.6;0.6 0.0],'transfer',@(t) 20+0.2.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*5*ndays))-0.2.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays*0.99))-0.54.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t)),0.5e1;... inner right boundary
    [1.0 0.0;1.0 1.0],'transfer',@(t) -5.1+0.4.*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*10*ndays)-4.2.*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays*0.99)-1.4.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t)),0.5e1;... outer right boundary
    [1.0 1.0;0.0 1.0],'transfer',@(t) -5.2+0.2*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*10*ndays)-4.8.*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays)-1.2.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t)),0.5e1};... outer left boundary
% PROBLEM.LoadDef.BC = {[0.0 0.6;0.6 0.6],'transfer',@(t) 15+0.5.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*5*ndays))-1.8.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays)),1e1;... inner left boundary
%                       [0.6 0.6;0.6 0.0],'transfer',@(t) 14+0.6.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*5*ndays))-2.1.*(cos(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays)),1e1;... inner right boundary
%                       [1.0 0.0;1.0 1.0],'transfer',@(t) -5.1+1.4.*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*10*ndays)-10.2.*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays),1e1;... outer right boundary
%                       [1.0 1.0;0.0 1.0],'transfer',@(t) -5.2+1.2*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*10*ndays)-9.8.*sin(2*pi/(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT).*t*ndays),1e1};... outer left boundary
% PROBLEM.LoadDef.BC = {[0.0 0.6;0.6 0.6],'transfer',@(t) 15+(t>(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT*0) & t<(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT*1)).*(cos(2*pi/(3600*10*24).*t*6)),1e1;... inner left boundary
%                       [0.6 0.6;0.6 0.0],'transfer',@(t) 14+(t>(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT*0) & t<(PROBLEM.TimeSettings.nT*PROBLEM.TimeSettings.dT*1)).*(cos(2*pi/(3600*8*24).*t*10)),1e1;... inner right boundary
%                       [1.0 0.0;1.0 1.0],'transfer',@(t) -2+1.4.*sin(2*pi/(3600*8*2*24*5).*t*10)+0.*t,1e1;... outer right boundary
%                       [1.0 1.0;0.0 1.0],'transfer',@(t) -2+1.2*(sin(2*pi/(3600*10*24).*t*15)),1e1};... outer left boundary
% %                       [0.0 1.0;0.0 0.6],'dirichlet',@(t) 1e-5+0.*t,NaN;... left boundary
% %                       [0.6 0.0;1.0 0.0],'dirichlet',@(t) 2.*sin(2*pi/(3600*60*24).*t*10),NaN};% bottom boundary


% %% Mesh setup
% MESH = load(fullfile('mesh',PROBLEM.General.MeshName),'-mat');



