function [x,y] = GCSchmidt(DipDir,Dip)
%
% function GCWulff: Calculate coordinates of a great circle on an equal-area spherical projection plot (Schmidt net)
% input: - DipDir, Dip: Coordinates of the plane
% output: - x, y: coordinates of the great circle that will be plot
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

psi=0:pi/50:pi;
rdip = Dip*(pi/180);
radip = atan(tan(rdip)*sin(psi));
rproj = sqrt(2)*sin((pi/2 - radip)/2);
x = rproj .* sin(psi);
y = rproj .* cos(psi);

thetaR1 = -90+DipDir; % Rotation angle
thetaR1 = -pi*(thetaR1)/180; % Transformation into rad
rot= ([cos(thetaR1) -sin(thetaR1) 0 ; sin(thetaR1) cos(thetaR1) 0 ; 0 0 1]); % Rotation matrix

for i=1:size(x,2)
    tmp= rot*[x(i) y(i) 0]';
    x(i)=tmp(1);
    y(i)=tmp(2);
end

end

