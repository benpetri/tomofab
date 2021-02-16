function [Vtot,params] = DistrAni(Vtot,params)
%
% function DistrAni: Calculates distribution anisotropy parameters
% input:    - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
% output:   - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
% references:
% - Schöpa, A., Floess, D., de Saint Blanquat, M., Annen, C., Launeau, P.,
%   2015. The relation between magnetite and silicate fabric in granitoids
%   of the Adamello Batholith. Tectonophysics 642, 1–15.
%   https://doi.org/10.1016/j.tecto.2014.11.022
% - Stephenson, A., 1994. Distribution anisotropy: two simple models for
%   magnetic lineation and foliation. Phys. Earth Planet. Inter. 82, 49–53.
%   https://doi.org/10.1016/0031-9201(94)90101-5
%               
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This file is part of TOMOFAB. Copyright (C) 2018-2021  Benoit Petri
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.
%      
%     Please report any bug, error or suggestion to bpetri@unistra.fr
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datacoord=params.posall; % Importing dataset
datavol=params.volall;

k=1;
len=size(datacoord,1)^2-size(datacoord,1);
vecs=zeros(len,3);
dist=zeros(len,1);
dirvec=zeros(len,3);
w=zeros(len,1);

for i=1:size(datacoord,1) % Calculates vectors and directional vectors betwen all points
    for j=i+1:size(datacoord,1)
        newvec=[datacoord(i,1)-datacoord(j,1) datacoord(i,2)-datacoord(j,2) datacoord(i,3)-datacoord(j,3)];
        vecs(k,:)=newvec;
        dist(k)=sqrt((datacoord(i,1)-datacoord(j,1))^2+(datacoord(i,2)-datacoord(j,2))^2+(datacoord(i,3)-datacoord(j,3))^2);
        dirvec(k,:)=newvec./dist(k); % Get directional vector (unit vector)
        if dirvec(k,3)>0 % Correction for upper hemisphere data
            dirvec(k,:) = -dirvec(k,:);
        end
        w(k)=(datavol(i)+datavol(j))/(pi*dist(k)^3); % Weighting factor from Stephenson (1994) and Schöpa et al. (2015):
        % gives more weight to large crystals that are close together
        k=k+1;
    end
end

%% Calculation of distribution anisotropy tensor
% Compiling orientation tensor for intergrain orientations, weighted by the
% w-factor from Stephenson (1994) and Schöpa et al. (2015)
Vtot.datens=zeros(3,3);

for i=1:size(dirvec,1)
    Vtot.datens(1,1) = Vtot.datens(1,1)+w(i)*dirvec(i,1)^2;
    Vtot.datens(2,2) = Vtot.datens(2,2)+w(i)*dirvec(i,2)^2;
    Vtot.datens(3,3) = Vtot.datens(3,3)+w(i)*dirvec(i,3)^2;
    Vtot.datens(1,2) = Vtot.datens(1,2)+w(i)*dirvec(i,1)*dirvec(i,2);
    Vtot.datens(1,3) = Vtot.datens(1,3)+w(i)*dirvec(i,1)*dirvec(i,3);
    Vtot.datens(2,3) = Vtot.datens(2,3)+w(i)*dirvec(i,2)*dirvec(i,3);
end
Vtot.datens(2,1) = Vtot.datens(1,2); % The tensor is symmetric, hence can be constructed after the loop
Vtot.datens(3,1) = Vtot.datens(1,3);
Vtot.datens(3,2) = Vtot.datens(2,3);
Vtot.datens = Vtot.datens/(size(dirvec,1));
Vtot.datens=Vtot.datens/sum(eig(Vtot.datens))*3; % Distribution anisotropy tensor normalization by its eigenvalues

[eigvec, eigval] = eig(Vtot.datens);
Vtot.dacart(1,:) = [eigvec(1,3) eigvec(2,3) eigvec(3,3)];
if Vtot.dacart(1,3)>0
    Vtot.dacart(1,:)=-Vtot.dacart(1,:);
end
[Vtot.dadeg(1,:)]=Cart2Deg(Vtot.dacart(1,:));

Vtot.dacart(2,:) = [eigvec(1,2) eigvec(2,2) eigvec(3,2)];
if Vtot.dacart(2,3)>0
    Vtot.dacart(2,:)=-Vtot.dacart(2,:);
end
[Vtot.dadeg(2,:)]=Cart2Deg(Vtot.dacart(2,:));

Vtot.dacart(3,:) = [eigvec(1,1) eigvec(2,1) eigvec(3,1)];
if Vtot.dacart(3,3)>0
    Vtot.dacart(3,:)=-Vtot.dacart(3,:);
end
[Vtot.dadeg(3,:)]=Cart2Deg(Vtot.dacart(3,:));

Vtot.daeigval=[eigval(3,3) eigval(2,2) eigval(1,1)];

% Now calculates shape parameters from the distribution anisotropy tensor
params.daK=[log(Vtot.daeigval(2)/Vtot.daeigval(3)) log(Vtot.daeigval(1)/Vtot.daeigval(2))];  %% Modified version by Ramsay (1967)
params.daT=(log(Vtot.daeigval(2)/Vtot.daeigval(3))-log(Vtot.daeigval(1)/Vtot.daeigval(2)))/(log(Vtot.daeigval(2)/Vtot.daeigval(3))+log(Vtot.daeigval(1)/Vtot.daeigval(2)));
mean=(Vtot.daeigval(3)+Vtot.daeigval(2)+Vtot.daeigval(1))/3;
params.daPj=exp(sqrt(2*((log(Vtot.daeigval(1)/mean))^2+(log(Vtot.daeigval(2)/mean))^2+(log(Vtot.daeigval(3)/mean))^2)));

end

