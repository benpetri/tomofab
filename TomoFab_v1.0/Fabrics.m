function [V1V2Deg, V1V3Deg, V2V3Deg] = Fabrics(V1Cart, V2Cart, V3Cart)
%
% function Fabrics: Calculates the V1-V2, V1-V3, V2-V3 planes
% input:    - V1, V2, V3 in cartesian coordinates
% output:   - planes dip direction / dip angle in degrees
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

%%
%% Coordinates transformation from cartesian to Dip Dir and Dip
%%
V1Sph = [0 0 0];
[V1Sph(1), V1Sph(2), V1Sph(3)]=cart2sph(V1Cart(1),V1Cart(2),V1Cart(3));
V2Sph = [0 0 0];
[V2Sph(1), V2Sph(2), V2Sph(3)]=cart2sph(V2Cart(1),V2Cart(2),V2Cart(3));
V3Sph = [0 0 0];
[V3Sph(1), V3Sph(2), V3Sph(3)]=cart2sph(V3Cart(1),V3Cart(2),V3Cart(3));
V1Deg = [0 0];
V1Deg(1)=-V1Sph(1)*180/pi+90;
V1Deg(2)=-V1Sph(2)*180/pi;
V2Deg = [0 0];
V2Deg(1)=-V2Sph(1)*180/pi+90;
V2Deg(2)=-V2Sph(2)*180/pi;
V3Deg = [0 0];
V3Deg(1)=-V3Sph(1)*180/pi+90;
V3Deg(2)=-V3Sph(2)*180/pi;
if V1Deg(1)<0
    V1Deg(1)=V1Deg(1)+360;
end
if V2Deg(1)<0
    V2Deg(1)=V2Deg(1)+360;
end
if V3Deg(1)<0
    V3Deg(1)=V3Deg(1)+360;
end

%% V1V2 plane calculation
V1V2Deg = zeros(size(V3Deg));

NormVec=cross(V1Cart,V2Cart);
[FolDipDir, FolDip, ~]=cart2sph(NormVec(1),NormVec(2),NormVec(3));

V1V2Deg(1) = FolDipDir;
V1V2Deg(2) = FolDip;

if V1V2Deg(2) <= 0
    V1V2Deg(1)=-V1V2Deg(1)*180/pi+90+180;
    V1V2Deg(2)=90+V1V2Deg(2)*180/pi;
else
    V1V2Deg(1)=V1V2Deg(1)-pi;
    V1V2Deg(2)=-V1V2Deg(2);
    V1V2Deg(1)=-V1V2Deg(1)*180/pi+90+180;
    V1V2Deg(2)=90+V1V2Deg(2)*180/pi;
end

if V1V2Deg(1) > 360
    V1V2Deg(1) = V1V2Deg(1)-360;
end

V1V2Deg = round(V1V2Deg,2);


%% V1V3 plane calculation
V1V3Deg = zeros(size(V2Deg));

NormVec=cross(V1Cart,V3Cart);
[FolDipDir, FolDip, ~]=cart2sph(NormVec(1),NormVec(2),NormVec(3));


V1V3Deg(1) = FolDipDir;
V1V3Deg(2) = FolDip;

if V1V3Deg(2) <= 0
    V1V3Deg(1)=-V1V3Deg(1)*180/pi+90+180;
    V1V3Deg(2)=90+V1V3Deg(2)*180/pi;
else
    V1V3Deg(1)=V1V3Deg(1)-pi;
    V1V3Deg(2)=-V1V3Deg(2);
    V1V3Deg(1)=-V1V3Deg(1)*180/pi+90+180;
    V1V3Deg(2)=90+V1V3Deg(2)*180/pi;
end

if V1V3Deg(1) > 360
    V1V3Deg(1) = V1V3Deg(1)-360;
end

V1V3Deg = round(V1V3Deg,2);


%% V2V3 plane calculation
V2V3Deg = zeros(size(V1Deg));

NormVec=cross(V2Cart,V3Cart);
[FolDipDir, FolDip, ~]=cart2sph(NormVec(1),NormVec(2),NormVec(3));

V2V3Deg(1) = FolDipDir;
V2V3Deg(2) = FolDip;

if V2V3Deg(2) <= 0
    V2V3Deg(1)=-V2V3Deg(1)*180/pi+90+180;
    V2V3Deg(2)=90+V2V3Deg(2)*180/pi;
else
    V2V3Deg(1)=V2V3Deg(1)-pi;
    V2V3Deg(2)=-V2V3Deg(2);
    V2V3Deg(1)=-V2V3Deg(1)*180/pi+90+180;
    V2V3Deg(2)=90+V2V3Deg(2)*180/pi;
end

if V2V3Deg(1) > 360
    V2V3Deg(1) = V2V3Deg(1)-360;
end

V2V3Deg = round(V2V3Deg,2);
end

