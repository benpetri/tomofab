function [V1,V2,V3,Vtot,params]=OrientationStatistics(V1,V2,V3,params,chb10,chb11,chb12)
%
% function OrientationStatistics: Calculates orientation statistics in various ways. See Tauxe (2002) for details.
% input:   - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - params: structure containing calculated parameters and
%           methods of calculation
%          - UIcontrol recording projection type
% output: - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
% references:
% - Fisher, R., 1953. Dispersion on a sphere. Proc. R. Soc. London. Ser.
%   A. Math. Phys. Sci. 217, 295 LP-305.
% - Hext, G.R., 1963. The Estimation of Second-Order Tensors, with 
%   Related Tests and Designs. Biometrika 50, 353-373.
%   https://doi.org/10.2307/2333905
% - Tauxe, L., 2002. Paleomagnetic principles and practice.
%   Kluwer, Dodrecht.
% - Petri, B., Almqvist, B.S.G., Pistone, M., 2020. 3D rock fabric analysis
%   using micro-tomography: An introduction to the open-source TomoFab
%   MATLAB code. Comput. Geosci. 138, 104444.
%   https://doi.org/10.1016/j.cageo.2020.104444
% - Scheidegger, A.E., 1965. On the statistics of the orientation of 
%   bedding planes, grain axes, and similar sedimentological data. US
%   Geol. Surv. Prof. Pap. 525, 164-167.
% - Jelinek, V., 1978. Statistical processing of anisotropy of magnetic
%   susceptibility measured on groups of specimens. Stud. Geophys. 
%   Geod. 22, 50-62. https://doi.org/10.1007/BF01613632
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


%% Calculation of orientation tensors
% Compiling orientation tensor for V1 directions
V1.ortens=zeros(3,3);

for i=1:size(V1.cosine,1)
    V1.ortens(1,1) = V1.ortens(1,1)+V1.cosine(i,1)^2;
    V1.ortens(2,2) = V1.ortens(2,2)+V1.cosine(i,2)^2;
    V1.ortens(3,3) = V1.ortens(3,3)+V1.cosine(i,3)^2;
    V1.ortens(1,2) = V1.ortens(1,2)+V1.cosine(i,1)*V1.cosine(i,2);
    V1.ortens(1,3) = V1.ortens(1,3)+V1.cosine(i,1)*V1.cosine(i,3);
    V1.ortens(2,3) = V1.ortens(2,3)+V1.cosine(i,2)*V1.cosine(i,3);
end
V1.ortens(2,1) = V1.ortens(1,2); % The orientation tensor is symmetric, hence can be constructed after the loop
V1.ortens(3,1) = V1.ortens(1,3);
V1.ortens(3,2) = V1.ortens(2,3);
V1.ortens = V1.ortens/(size(V1.cosine,1));
V1.oteigval=abs(sort(eig(V1.ortens)));

% Compiling orientation tensor for V2 directions
V2.ortens=zeros(3,3);
for i=1:size(V2.cosine,1)
    V2.ortens(1,1) = V2.ortens(1,1)+V2.cosine(i,1)^2;
    V2.ortens(2,2) = V2.ortens(2,2)+V2.cosine(i,2)^2;
    V2.ortens(3,3) = V2.ortens(3,3)+V2.cosine(i,3)^2;
    V2.ortens(1,2) = V2.ortens(1,2)+V2.cosine(i,1)*V2.cosine(i,2);
    V2.ortens(1,3) = V2.ortens(1,3)+V2.cosine(i,1)*V2.cosine(i,3);
    V2.ortens(2,3) = V2.ortens(2,3)+V2.cosine(i,2)*V2.cosine(i,3);
end
V2.ortens(2,1) = V2.ortens(1,2);
V2.ortens(3,1) = V2.ortens(1,3);
V2.ortens(3,2) = V2.ortens(2,3);
V2.ortens = V2.ortens/(size(V2.cosine,1));
V2.oteigval=abs(sort(eig(V2.ortens)));

% Compiling orientation tensor for V3 directions
V3.ortens=zeros(3,3);
for i=1:size(V3.cosine,1)
    V3.ortens(1,1) = V3.ortens(1,1)+V3.cosine(i,1)^2;
    V3.ortens(2,2) = V3.ortens(2,2)+V3.cosine(i,2)^2;
    V3.ortens(3,3) = V3.ortens(3,3)+V3.cosine(i,3)^2;
    V3.ortens(1,2) = V3.ortens(1,2)+V3.cosine(i,1)*V3.cosine(i,2);
    V3.ortens(1,3) = V3.ortens(1,3)+V3.cosine(i,1)*V3.cosine(i,3);
    V3.ortens(2,3) = V3.ortens(2,3)+V3.cosine(i,2)*V3.cosine(i,3);
end
V3.ortens(2,1) = V3.ortens(1,2);
V3.ortens(3,1) = V3.ortens(1,3);
V3.ortens(3,2) = V3.ortens(2,3);
V3.ortens = V3.ortens/(size(V3.cosine,1));
V3.oteigval=abs(sort(eig(V3.ortens)));

% Compiling mean fabric tensor
Vtot.fabtens=zeros(3,3); % Mean fabric tensor

if get(chb12,'value')==1 % Use non-standardized samples, calculations will be affected by the biggest ellipsoids
    for i=1:size(V1.cosine,1)
        params.standard='no';
        if get(chb11,'value')==1 % Linear fabric tensor constructed with axes length
            params.tenstype='linear';
            Vtot.fabtens(1,1) = Vtot.fabtens(1,1)+V1.length(i)*V1.cosine(i,1)^2+V2.length(i)*V2.cosine(i,1)^2+V3.length(i)*V3.cosine(i,1)^2;
            Vtot.fabtens(2,2) = Vtot.fabtens(2,2)+V1.length(i)*V1.cosine(i,2)^2+V2.length(i)*V2.cosine(i,2)^2+V3.length(i)*V3.cosine(i,2)^2;
            Vtot.fabtens(3,3) = Vtot.fabtens(3,3)+V1.length(i)*V1.cosine(i,3)^2+V2.length(i)*V2.cosine(i,3)^2+V3.length(i)*V3.cosine(i,3)^2;
            Vtot.fabtens(1,2) = Vtot.fabtens(1,2)+V1.length(i)*V1.cosine(i,1)*V1.cosine(i,2)+V2.length(i)*V2.cosine(i,1)*V2.cosine(i,2)+V3.length(i)*V3.cosine(i,1)*V3.cosine(i,2);
            Vtot.fabtens(1,3) = Vtot.fabtens(1,3)+V1.length(i)*V1.cosine(i,1)*V1.cosine(i,3)+V2.length(i)*V2.cosine(i,1)*V2.cosine(i,3)+V3.length(i)*V3.cosine(i,1)*V3.cosine(i,3);
            Vtot.fabtens(2,3) = Vtot.fabtens(2,3)+V1.length(i)*V1.cosine(i,2)*V1.cosine(i,3)+V2.length(i)*V2.cosine(i,2)*V2.cosine(i,3)+V3.length(i)*V3.cosine(i,2)*V3.cosine(i,3);
        elseif get(chb11,'value')==2 % Quadratic fabric tensor constructed with squared axes length
            params.tenstype='quadratic';
            Vtot.fabtens(1,1) = Vtot.fabtens(1,1)+V1.length(i)^2*V1.cosine(i,1)^2+V2.length(i)^2*V2.cosine(i,1)^2+V3.length(i)^2*V3.cosine(i,1)^2;
            Vtot.fabtens(2,2) = Vtot.fabtens(2,2)+V1.length(i)^2*V1.cosine(i,2)^2+V2.length(i)^2*V2.cosine(i,2)^2+V3.length(i)^2*V3.cosine(i,2)^2;
            Vtot.fabtens(3,3) = Vtot.fabtens(3,3)+V1.length(i)^2*V1.cosine(i,3)^2+V2.length(i)^2*V2.cosine(i,3)^2+V3.length(i)^2*V3.cosine(i,3)^2;
            Vtot.fabtens(1,2) = Vtot.fabtens(1,2)+V1.length(i)^2*V1.cosine(i,1)*V1.cosine(i,2)+V2.length(i)^2*V2.cosine(i,1)*V2.cosine(i,2)+V3.length(i)^2*V3.cosine(i,1)*V3.cosine(i,2);
            Vtot.fabtens(1,3) = Vtot.fabtens(1,3)+V1.length(i)^2*V1.cosine(i,1)*V1.cosine(i,3)+V2.length(i)^2*V2.cosine(i,1)*V2.cosine(i,3)+V3.length(i)^2*V3.cosine(i,1)*V3.cosine(i,3);
            Vtot.fabtens(2,3) = Vtot.fabtens(2,3)+V1.length(i)^2*V1.cosine(i,2)*V1.cosine(i,3)+V2.length(i)^2*V2.cosine(i,2)*V2.cosine(i,3)+V3.length(i)^2*V3.cosine(i,2)*V3.cosine(i,3);
        end
    end
elseif get(chb12,'value')==2 % Use standardized samples, all ellipsoids will have the same weight
    for i=1:size(V1.cosine,1)
        params.standard='yes';
        R=sqrt(V1.length(i)^2+V2.length(i)^2+V3.length(i)^2); % standardization for a "unit" ellipsoid
%         R=V1.length(i); % standardization by the V1 length
        if get(chb11,'value')==1 % Linear fabric tensor constructed with axes length
            params.tenstype='linear';
            Vtot.fabtens(1,1) = Vtot.fabtens(1,1)+(V1.length(i)/R)*V1.cosine(i,1)^2+(V2.length(i)/R)*V2.cosine(i,1)^2+(V3.length(i)/R)*V3.cosine(i,1)^2;
            Vtot.fabtens(2,2) = Vtot.fabtens(2,2)+(V1.length(i)/R)*V1.cosine(i,2)^2+(V2.length(i)/R)*V2.cosine(i,2)^2+(V3.length(i)/R)*V3.cosine(i,2)^2;
            Vtot.fabtens(3,3) = Vtot.fabtens(3,3)+(V1.length(i)/R)*V1.cosine(i,3)^2+(V2.length(i)/R)*V2.cosine(i,3)^2+(V3.length(i)/R)*V3.cosine(i,3)^2;
            Vtot.fabtens(1,2) = Vtot.fabtens(1,2)+(V1.length(i)/R)*V1.cosine(i,1)*V1.cosine(i,2)+(V2.length(i)/R)*V2.cosine(i,1)*V2.cosine(i,2)+(V3.length(i)/R)*V3.cosine(i,1)*V3.cosine(i,2);
            Vtot.fabtens(1,3) = Vtot.fabtens(1,3)+(V1.length(i)/R)*V1.cosine(i,1)*V1.cosine(i,3)+(V2.length(i)/R)*V2.cosine(i,1)*V2.cosine(i,3)+(V3.length(i)/R)*V3.cosine(i,1)*V3.cosine(i,3);
            Vtot.fabtens(2,3) = Vtot.fabtens(2,3)+(V1.length(i)/R)*V1.cosine(i,2)*V1.cosine(i,3)+(V2.length(i)/R)*V2.cosine(i,2)*V2.cosine(i,3)+(V3.length(i)/R)*V3.cosine(i,2)*V3.cosine(i,3);
        elseif get(chb11,'value')==2 % Quadratic fabric tensor constructed with squared axes length
            params.tenstype='quadratic';
            Vtot.fabtens(1,1) = Vtot.fabtens(1,1)+(V1.length(i)/R)^2*V1.cosine(i,1)^2+(V2.length(i)/R)^2*V2.cosine(i,1)^2+(V3.length(i)/R)^2*V3.cosine(i,1)^2;
            Vtot.fabtens(2,2) = Vtot.fabtens(2,2)+(V1.length(i)/R)^2*V1.cosine(i,2)^2+(V2.length(i)/R)^2*V2.cosine(i,2)^2+(V3.length(i)/R)^2*V3.cosine(i,2)^2;
            Vtot.fabtens(3,3) = Vtot.fabtens(3,3)+(V1.length(i)/R)^2*V1.cosine(i,3)^2+(V2.length(i)/R)^2*V2.cosine(i,3)^2+(V3.length(i)/R)^2*V3.cosine(i,3)^2;
            Vtot.fabtens(1,2) = Vtot.fabtens(1,2)+(V1.length(i)/R)^2*V1.cosine(i,1)*V1.cosine(i,2)+(V2.length(i)/R)^2*V2.cosine(i,1)*V2.cosine(i,2)+(V3.length(i)/R)^2*V3.cosine(i,1)*V3.cosine(i,2);
            Vtot.fabtens(1,3) = Vtot.fabtens(1,3)+(V1.length(i)/R)^2*V1.cosine(i,1)*V1.cosine(i,3)+(V2.length(i)/R)^2*V2.cosine(i,1)*V2.cosine(i,3)+(V3.length(i)/R)^2*V3.cosine(i,1)*V3.cosine(i,3);
            Vtot.fabtens(2,3) = Vtot.fabtens(2,3)+(V1.length(i)/R)^2*V1.cosine(i,2)*V1.cosine(i,3)+(V2.length(i)/R)^2*V2.cosine(i,2)*V2.cosine(i,3)+(V3.length(i)/R)^2*V3.cosine(i,2)*V3.cosine(i,3);
        end
    end
end

Vtot.fabtens(2,1) = Vtot.fabtens(1,2);
Vtot.fabtens(3,1) = Vtot.fabtens(1,3);
Vtot.fabtens(3,2) = Vtot.fabtens(2,3);
Vtot.fabtens=Vtot.fabtens/sum(eig(Vtot.fabtens))*3; % Fabric tensor normalization by its eigenvalues


%% Axis (vector) approach following Fisher (1963). Estimates mean directions independently. Resulting mean directions will likely NOT be orthogonal
% Allows Fisher confidence cone calculation. See ConfidenceFisher function for details.
if get(chb10,'Value') == 2

    params.ormeth='axis'; % Update used mean orientation method
    
    [V1,V2,V3,params] = ShapeParams(V1,V2,V3,Vtot,params);

    sumx=0;
    sumy=0;
    sumz=0;
    for i=1:size(V1.cosine,1)
        sumx=sumx+V1.cosine(i,1);
        sumy=sumy+V1.cosine(i,2);
        sumz=sumz+V1.cosine(i,3);
    end
    R=sqrt(sumx^2+sumy^2+sumz^2);
    V1.meancart=[sumx/R sumy/R sumz/R];
    [V1.meandeg]=Cart2Deg(V1.meancart);
    clearvars sumx sumy sumz R
    
    sumx=0;
    sumy=0;
    sumz=0;
    for i=1:size(V2.cosine,1)
        sumx=sumx+V2.cosine(i,1);
        sumy=sumy+V2.cosine(i,2);
        sumz=sumz+V2.cosine(i,3);
    end
    R=sqrt(sumx^2+sumy^2+sumz^2);
    V2.meancart=[sumx/R sumy/R sumz/R];
    [V2.meandeg]=Cart2Deg(V2.meancart);
    clearvars sumx sumy sumz R

    sumx=0;
    sumy=0;
    sumz=0;
    for i=1:size(V3.cosine,1)
        sumx=sumx+V3.cosine(i,1);
        sumy=sumy+V3.cosine(i,2);
        sumz=sumz+V3.cosine(i,3);
    end
    R=sqrt(sumx^2+sumy^2+sumz^2);
    V3.meancart=[sumx/R sumy/R sumz/R];
    [V3.meandeg]=Cart2Deg(V3.meancart);
    clearvars sumx sumy sumz R
end

%% Orientation tensor approach. dependent. Estimates mean directions independently by using the orientation tensor of each principal direction. Resulting mean directions will likely NOT be orthogonal. Follows the approach of Scheidegger (1965) and many others afterwards.
% Summ of the fabric tensor of each sample. Allows Hext (1953) and Jelinek (1978)
% confidence cones calculation.

if get(chb10,'Value') == 3
    params.ormeth='ortens'; % Update mean orientation method
    
    [eigvec, ~] = eig(V1.ortens);
    V1.meancart = [eigvec(1,3) eigvec(2,3) eigvec(3,3)];
    if V1.meancart(3)>0
        V1.meancart=-V1.meancart;
    end
    [V1.meandeg]=Cart2Deg(V1.meancart);
    
    [eigvec, ~] = eig(V2.ortens);
    V2.meancart = [eigvec(1,3) eigvec(2,3) eigvec(3,3)];
    if V2.meancart(3)>0
        V2.meancart=-V2.meancart;
    end
    [V2.meandeg]=Cart2Deg(V2.meancart);
    
    [eigvec, ~] = eig(V3.ortens);
    V3.meancart = [eigvec(1,3) eigvec(2,3) eigvec(3,3)];
    if V3.meancart(3)>0
        V3.meancart=-V3.meancart;
    end
    [V3.meandeg]=Cart2Deg(V3.meancart);
    
%     Vtot.fteigval=[eigval(3,3) eigval(2,2) eigval(1,1)];
    
    [V1,V2,V3,params] = ShapeParams(V1,V2,V3,Vtot,params); % Compile shape parameters
end


%% Fabric tensor approach. All directions distribution are dependent. Fabric tensor calculated following the approach of Petri et al. (2020).
% Summ of the fabric tensor of each sample. Allows Hext (1953) and Jelinek (1978)
% confidence cones calculation.

if get(chb10,'Value') == 4
    params.ormeth='fabtens'; % Update mean orientation method
    
    [eigvec, eigval] = eig(Vtot.fabtens);
    V1.meancart = [eigvec(1,3) eigvec(2,3) eigvec(3,3)];
    if V1.meancart(3)>0
        V1.meancart=-V1.meancart;
    end
    [V1.meandeg]=Cart2Deg(V1.meancart);
    
    V2.meancart = [eigvec(1,2) eigvec(2,2) eigvec(3,2)];
    if V2.meancart(3)>0
        V2.meancart=-V2.meancart;
    end
    [V2.meandeg]=Cart2Deg(V2.meancart);
    
    V3.meancart = [eigvec(1,1) eigvec(2,1) eigvec(3,1)];
    if V3.meancart(3)>0
        V3.meancart=-V3.meancart;
    end
    [V3.meandeg]=Cart2Deg(V3.meancart);
    
    Vtot.fteigval=[eigval(3,3) eigval(2,2) eigval(1,1)];
    
    [V1,V2,V3,params] = ShapeParams(V1,V2,V3,Vtot,params); % Compile shape parameters
end


%% Case where no orientation statistics are asked.
if get(chb10,'Value')==1
    V1.meancart=0;
    V2.meancart=0;
    V3.meancart=0;
    Vtot.fabtens=zeros(1,1);
    params.ormeth='none';
    [V1,V2,V3,params] = ShapeParams(V1,V2,V3,Vtot,params);
end


end


