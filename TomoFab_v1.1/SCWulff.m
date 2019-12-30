function [x,y] = SCWulff(DipDir,Dip)
%
% function SCWulff: Calculate coordinates of a small circle on an equal-angle spherical projection plot (Wulff net)
% input:	- DipDir, Dip: Coordinates of the plane
% output:   - x, y: coordinates of the great circle that will be plot
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This file is part of TOMOFAB. Copyright (C) 2018-2019  Benoit Petri
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

alpha = Dip*(pi/180);
xlim = sin(alpha);
x = -xlim:0.01:xlim;
d = 1/cos(alpha);
rd = d*sin(alpha);
y0 = sqrt(rd*rd - (x .* x));
y = d - y0;


thetaR1 = DipDir; % Rotation angle
thetaR1 = -pi*(thetaR1)/180; % Transformation into rad
rot= ([cos(thetaR1) -sin(thetaR1) 0 ; sin(thetaR1) cos(thetaR1) 0 ; 0 0 1]); % Rotation matrix

for i=1:size(x,2)
    tmp= rot*[x(i) y(i) 0]';
    x(i)=tmp(1);
    y(i)=tmp(2);
end

end
