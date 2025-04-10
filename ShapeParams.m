function [V1,V2,V3,params] = ShapeParams(V1,V2,V3,Vtot,params)
%
% function ShapeParams: Calculates various shape parameters on blobs and mean orientation tensor
% input:    - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
% references:
% - Jelinek, V., 1981. Characterization of the magnetic fabric of rocks. 
% Tectonophysics 79, T63-T67. doi:https://doi.org/10.1016/0040-1951(81)90110-4
% - Ulrich, S., Mainprice, D., 2005. Does cation ordering in omphacite 
% influence development of lattice-preferred orientation? J. Struct. Geol. 
% 27, 419-431. https://doi.org/http://dx.doi.org/10.1016/j.jsg.2004.11.003
% - Woodcock, N.H., 1977. Specification of fabric shapes using an eigenvalue
% method. Geol. Soc. Am. Bull. 88, 1231.
% https://doi.org/10.1130/0016-7606(1977)88<1231:SOFSUA>2.0.CO;2
% - Vollmer, F.W., 1990. An application of eigenvalue methods to structural
% domain analysis. Geol. Soc. Am. Bull. 102, 786-791.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This file is part of TOMOFAB. Copyright (C) 2018-2025  Benoit Petri
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


% Shape parameters for each blob (classical Flynn diagram definition):
% x = R2/R3, y= R1/R2
params.Kall=zeros(size(V1.length,1),2);
for i=1:size(V1.cosine,1)
    %     params.Kall(i,:)=[V2.length(i)/V3.length(i) V1.length(i)/V2.length(i)]; %% Classical Flinn (1962)
    params.Kall(i,:)=[log(V2.length(i)/V3.length(i)) log(V1.length(i)/V2.length(i))]; %% Modified version by Ramsay (1967)
end

%% Computing orientation statistics

% Data distribution folowing Woodcock (1977): [inf - 1]: linear; [1 - 0]: planar
params.Kmean=log(V1.oteigval(3)/V1.oteigval(2))/log(V1.oteigval(2)/V1.oteigval(1));

% Data distribution folowing Ulrich and Mainprice (2005) and after calculating Vollmer's parameters (Vollmer, 1990): LS = 1 if linear; % LS = 0 if planar
V1.PGR=zeros(3,1);
V1.PGR(1)=V1.oteigval(3)-V1.oteigval(2);
V1.PGR(2)=2*(V1.oteigval(2)-V1.oteigval(1));
V1.PGR(3)=3*V1.oteigval(1);

V2.PGR=zeros(3,1);
V2.PGR(1)=V2.oteigval(3)-V2.oteigval(2);
V2.PGR(2)=2*(V2.oteigval(2)-V2.oteigval(1));
V2.PGR(3)=3*V2.oteigval(1);

V3.PGR=zeros(3,1);
V3.PGR(1)=V3.oteigval(3)-V3.oteigval(2);
V3.PGR(2)=2*(V3.oteigval(2)-V3.oteigval(1));
V3.PGR(3)=3*V3.oteigval(1);

params.LS=1/2*(2-(V3.PGR(1)/(V3.PGR(2)+V3.PGR(1)))-(V1.PGR(2)/(V1.PGR(2)+V1.PGR(1))));

% Jelinek fabric parameters (Jelinek, 1981)
params.Tall=zeros(size(V1.cosine,1),1);
params.Pjall=zeros(size(V1.cosine,1),1);

for i=1:size(V1.cosine,1) % Calculates the T and P' parameters for each individual ellipsoid of the selected dataset.
    params.Tall(i) = (log(V2.length(i)/V3.length(i))-log(V1.length(i)/V2.length(i)))/(log(V2.length(i)/V3.length(i))+log(V1.length(i)/V2.length(i)));  % T shape parameter
    mean=(V1.length(i)+V2.length(i)+V3.length(i))/3;
    params.Pjall(i) =  exp(sqrt(2*((log(V1.length(i)/mean))^2+(log(V2.length(i)/mean))^2+(log(V3.length(i)/mean))^2)));  % P' anisotropy
end

if strcmp(params.ormeth,'fabtens') % Calculates the T and P' parameters for the mean fabric tensor if fabric tensor analysis is selected
    params.Tmean=(log(Vtot.fteigval(2)/Vtot.fteigval(3))-log(Vtot.fteigval(1)/Vtot.fteigval(2)))/(log(Vtot.fteigval(2)/Vtot.fteigval(3))+log(Vtot.fteigval(1)/Vtot.fteigval(2)));
    mean=(Vtot.fteigval(3)+Vtot.fteigval(2)+Vtot.fteigval(1))/3;
    params.Pjmean=exp(sqrt(2*((log(Vtot.fteigval(1)/mean))^2+(log(Vtot.fteigval(2)/mean))^2+(log(Vtot.fteigval(3)/mean))^2)));
else % Tensor analysis is not selected, set T and P' to zero
    params.Tmean=0;
    params.Pjmean=0;
end




end

