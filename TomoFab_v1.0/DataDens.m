function [x,y,z] = DataDens(PointsCart,chb1,chb8)
%
% function DataDens: Compile density diagrams using a Kalsbeek counting net
% (Kalsbeek, 1963)
% input:    - PointsCart: set of points in cartesian coordinates 
%           (directional cosines)
%           - set of UIcontrol recording user requests
% output:   - x, y: Coordinates of points that will be displaid
%           - z: results of the couting in % per 1% area
% references:
% - Kalsbeek, F., 1963. A hexagonal net for the counting out and testing of
% fabric diagrams. Neues Jahrb. für Mineral. Monatshefte 7, 173–176.
%
% This function is inspired from Ramon Arrowsmith and Don Ragan
% http://activetectonics.la.asu.edu/Structural_Geology/contouring/
% Last accessed on 12 December 2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This file is part of µTOMOFAB. Copyright (C) 2018-2019  Benoit Petri
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

rad = pi/180;
deg = 180/pi;

limit = -0.3;
j=1;


NewPoints=zeros(sum(PointsCart(:,3)>=limit),3); % Duplicate points close to the horizon
for i=1:size(PointsCart,1)
    if PointsCart(i,3)>=limit
        NewPoints(j,1)=-PointsCart(i,1);
        NewPoints(j,2)=-PointsCart(i,2);
        NewPoints(j,3)=-PointsCart(i,3);
        j=j+1;
    end
end


n = 1;
p(n) = 90;
t(n) = 0;

for i = 1:10
    m = 6*i;
    radius = i/10;
    DeltaPhi = 360/m;
    for j = 1:m
        phi = j*DeltaPhi;
        n = n+1;
        t(n) = phi;
        theta = 2 * asin(radius/sqrt(2));
        p(n) = 90 - (theta*deg);
    end
end


% Nodes coordinates
Ln=zeros(1,331);
Mn=zeros(1,331);
Nn=zeros(1,331);

for i = 1:331
    Ln(i) = cos(p(i)*rad) * cos(t(i)*rad);
    Mn(i) = cos(p(i)*rad) * sin(t(i)*rad);
    Nn(i) = -sin(p(i)*rad);
end

% Nodes coordinates in degrees

[nodesdeg]=Cart2Deg([Ln;Mn;Nn]');

if get(chb1,'Value')==1
    [x,y]=SchmidtParams(nodesdeg);
elseif get(chb1,'Value')==2
    [x,y]=WulffParams(nodesdeg);
end


% Couting cone definition

Ndata=size(PointsCart,1);
key = 2.0;
cone = (acos(Ndata/(Ndata+key^2)))*deg;



z=zeros(1,331);
for i = 1:331 % Let's count
    z(i) = 0;
    for j = 1:size(PointsCart,1)
        theta = (acos(Ln(i)*PointsCart(j,1) + Mn(i)*PointsCart(j,2) + Nn(i)*PointsCart(j,3)))*deg;
        if theta <= cone
            z(i) = z(i)+1;
        end
    end
end

Zmax = 0;
for j = 1:331
    z(j) = (z(j)/Ndata)*100;  % Convert to percent
    if z(j) > Zmax
        Zmax = z(j);
    end
end

if get(chb8,'Value')==2
    binsize=0.01;
    [X,Y] = meshgrid(-1:binsize:1,-1:binsize:1);
    [xi,yi,Counts] = griddata(x,y,z,X,Y, 'cubic'); % Counts cubic interpolation
    clearvars x y z
    x=xi;
    y=yi;
    z=Counts;
end

% Counts(isnan(Counts))=0; % unactivate if you wish to delete NaN values



end

