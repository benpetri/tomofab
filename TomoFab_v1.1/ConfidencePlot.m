function [Ell]=ConfidencePlot(Ell,AxisCoord,Color,chb1)
%
% function ConfidencePlot: Plots confidence ellipses on a spherical
% projection plot
% input:    - Ell: coordinatees of points constituting the confidence
%           ellipses
%           - AxisCoord: coordinates of the axis anchoring the ellipse
%           - Color: color of the ellipse
%           - chb1: requested projection
% output:   - Ell: recalculated ellipse coordinates
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

[Ell, revrec]=Rotator([AxisCoord 0 0],Ell); % anchor the ellipse to its right point
[EllDeg]=Cart2Deg(Ell);
if get(chb1,'Value')==1 % Calculates the coordinates on the spherical projection plot
    [xel,yel]=SchmidtParams(EllDeg);
elseif get(chb1,'Value')==2
    [xel,yel]=WulffParams(EllDeg);
end

fsize=1; 
for k=2:size(xel) % loop to quantify the number of rows requested to draw nice ellipses
    if revrec(k-1) ~= revrec(k)
        fsize=fsize+1;
    end
end

cutxel=cell(fsize,1);
cutyel=cell(fsize,1);

cutxel{1}=xel(1);
cutyel{1}=yel(1);
nameinc=1;

for k=2:size(xel) % Cut the ellipse coordinates into indepentent curves to avoid connecting lines if they are separated in different segments
    if revrec(k-1) == revrec(k)
        A = cutxel{nameinc};
        B = cutyel{nameinc};
        cutxel{nameinc}=[A xel(k)];
        cutyel{nameinc}=[B yel(k)];
    else
        nameinc=nameinc+1;
        A = cutxel{nameinc};
        B = cutyel{nameinc};
        cutxel{nameinc}=[A xel(k)];
        cutyel{nameinc}=[B yel(k)];
    end
end

for i=1:fsize % Plot all segments
    plot(cutxel{i},cutyel{i},'Color',Color) 
end


end

