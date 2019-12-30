function [xp,yp] = SchmidtParams(Points)
%
% function SchmidtParams: Calculates coordinates of points on an equal-area spherical projection plot (Schmidt net)
% input: - Points directions in degrees
% output: - xp, yp: coordinates of points on the stereonet
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

theta = pi*(Points(:,1))/180;
rho = pi*(Points(:,2))/180;
xp=zeros(size(theta));
yp=zeros(size(theta));
for i=1:size(theta)
    trd=theta(i);
    plg=rho(i);
    if plg < 0.0
        trd = ZeroTwoPi(trd+pi);
        plg = -plg;
    end
    piS4 = pi/4.0;
    s2 = sqrt(2.0);
    plgS2 = plg/2.0;
    xpt = s2*sin(piS4 - plgS2)*sin(trd);
    ypt = s2*sin(piS4 - plgS2)*cos(trd);
    xp(i)=xpt;
    yp(i)=ypt;
end

end



