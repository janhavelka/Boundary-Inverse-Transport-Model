
function MATERIAL = GTM_getMaterial(MESH,PROBLEM)
% not complete function, should contain sophistical functions to get
% various material fields etc




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


% % define real material conductvity L_holes
% true_mat=@(x,y) 1 + 0.*x + 0.*y;
% MATERIAL.sigma_true=true_mat(MESH.Elements(:,5),MESH.Elements(:,6));




% sigma_fun = @(x,y) 1/15.*(abs((5+3*x.^2+2*y-y.*x-5*sin(x/0.075).*y+2*cos(y/0.1).*x*5))+5);
% % true_mat=@(x,y) 0.*x+1;
% MATERIAL.sigma_true = sigma_fun(MESH.Elements(:,5),MESH.Elements(:,6));

% define real material conductvity L_holes
true_mat=@(x,y) abs((5+3*x.^2+2*y-y.*x-5*sin(x/0.075).*y+2*cos(y/0.1).*x*5))+5;
sigma_nodes=true_mat(MESH.Nodes(:,1),MESH.Nodes(:,2));

coords_rectangle=[0,0.5;
    0.2 0.5;
    0.2 0;
    0 0;
    0 0.5]+ones(5,2)*[0.7 0; 0 0.1];
% coords_rectangle=[0,0.5;
%     0.6 0.5;
%     0.6 0;
%     0 0;
%     0 0.5]+ones(5,2)*[0.6 0; 0 0];
rectangle = inpoly(MESH.Nodes,coords_rectangle);
sigma_nodes(rectangle)=25;

MATERIAL.sigma_true=MESH.NTE*sigma_nodes;




% % % circle, 2-inclusions
% sigma_nodes=zeros(MESH.nnodes,1);
% 
% theta = 0:pi/10:(2*pi-pi/10);
% % create bounded circle region #1 (left)
% rb1=0.2;
% x = rb1.*cos(theta)/2;
% y = rb1.*sin(theta)/2;
% % position of the center
% xbc1=-0.25;
% ybc1=-0.15;
% circle_1 = inpoly(MESH.Nodes,[x'+xbc1, y'+ybc1]);
% 
% % create bounded circle region #2 (right)
% rb2=0.4;
% x = rb2.*cos(theta)/2;
% y = rb2.*sin(theta)/2;
% % position of the center
% xbc2=0.2;
% ybc2=0.05;
% circle_2 = inpoly(MESH.Nodes,[x'+xbc2, y'+ybc2]);
% 
% sigma_nodes(:)=1.5;
% sigma_nodes(circle_1)=2.0;
% sigma_nodes(circle_2)=1.0;
% MATERIAL.sigma_true=MESH.NTE*sigma_nodes;








% define real material conductvity
% true_mat=@(x,y) 1./(5+3*x.^2+2*y-y.*x)*100;

% variable in all directions
% true_mat=@(x,y) abs((5+3*x.^2+2*y-y.*x-5*sin(x/0.075).*y+2*cos(y/0.1).*x*5))+5;
% MATERIAL.sigma_true=true_mat(MESH.Elements(:,5),MESH.Elements(:,6));

% % normal distribution in X
% sigma=0.15/1.5;
% mu=0.15;
% magnitude=10;
% true_mat=@(x,y) magnitude.*exp(-(x-mu).^2/(2*sigma^2));
% MATERIAL.sigma_true=true_mat(MESH.Elements(:,5),MESH.Elements(:,6));

% % normal distribution in Y
% sigma=0.5/1.5;
% mu=0.5;
% magnitude=10;
% true_mat=@(x,y) magnitude.*exp(-(y-mu).^2/(2*sigma^2));
% MATERIAL.sigma_true=true_mat(MESH.Elements(:,5),MESH.Elements(:,6));


% sigma_nodes=zeros(MESH.nnodes,1);
% idx=(MESH.Nodes(:,1)>0.6 & MESH.Nodes(:,1)<0.8) & (MESH.Nodes(:,2)>0.6 & MESH.Nodes(:,2)<0.8);
% sigma_nodes(idx)=20;
% sigma_nodes(~idx)=10;
% MATERIAL.sigma_true=MESH.NTE*sigma_nodes;

% sigma_nodes=zeros(MESH.nnodes,1);
% idx=(MESH.Nodes(:,1)>0.6 & MESH.Nodes(:,1)<0.8) & (MESH.Nodes(:,2)>0.6 & MESH.Nodes(:,2)<0.8);
% idx2=(MESH.Nodes(:,1)>0.8 & MESH.Nodes(:,1)<1) & (MESH.Nodes(:,2)>0.1 & MESH.Nodes(:,2)<0.3);
% sigma_nodes(idx)=4;
% sigma_nodes(idx2)=0.5;
% sigma_nodes(~idx & ~idx2)=2;
% MATERIAL.sigma_true=MESH.NTE*sigma_nodes;

























