function [PointsDeg] = Cart2Deg(PointsCart)
%
% function Cart2Deg: Transforms directional cosines (cartesian coordinates)
% to Dip direction / Dip angles coordinates
% input:    - PointsCart: Coordinates of points in cartesian coordinates
% output:   - PointsDeg: Coordinates of points in DipDir / Dip
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

PointsSph=zeros(size(PointsCart,1),3);
PointsDeg=zeros(size(PointsCart,1),2);

for i=1:size(PointsCart,1)
    [PointsSph(i,1), PointsSph(i,2), PointsSph(i,3)]=cart2sph(PointsCart(i,1),PointsCart(i,2),PointsCart(i,3));
    PointsDeg(i,1)=round(-PointsSph(i,1)*180/pi+90,1);
    PointsDeg(i,2)=round(-PointsSph(i,2)*180/pi,1);
    if PointsDeg(i,1)<0
        PointsDeg(i,1)=PointsDeg(i,1)+360;
    end
end