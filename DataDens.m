function [contours, grid, params] = DataDens(PointsCart,chb1,chb8,chb18,Text26,params)
%
% function DataDens: Compile density contours by the modified Kamb method
% proposed by Vollmer (1995).
% input:    - PointsCart: set of points in cartesian coordinates
%           (directional cosines)
%           - set of UIcontrol recording user requests
% output:   - contours: coordinates calculated contour lines
%           - grid: calculated density grid
% references:
% - Vollmer, F.W., 1995. C program for automatic contouring of spherical
% orientation data using a modified Kamb method. Comput. Geosci. 21,
% 31-49. doi:10.1016/0098-3004(94)00058-3
% - Adapted from the MATLAB routine available at https://github.com/vollmerf
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


if get(chb8,'Value')==1 % Low quality counting grid if wanted
    ngrid = 30; % 30
elseif get(chb8,'Value')==2 % High quality counting grid is wanted
    ngrid = 50; % 50
end

nlevels = str2double(get(Text26,'String')); % Get contours number
sigma = 3.0;
interpparam = 0.2;
[grid, contours] = contour(PointsCart, ngrid, sigma, nlevels, chb1);
if get(chb18,'Value')==2
    grid=grid/sigma;
end
params.denslim=[min(min(grid)) max(max(grid))];
grid = processGrid(grid, interpparam);
end

% Function contour - grids data and outputs contours.
function [grid, lines] = contour(dc, ngrid, sigma, nlevels, chb1)
grid = gridKamb(dc, ngrid, sigma, chb1);
zmin = min(min(grid));
zmax = max(max(grid));
x1 = -1.0;
y1 = -1.0;
x2 = 1.0;
y2 = 1.0;
lines = zeros(0,4);
zinc = (zmax-zmin)/nlevels;
level = zmin;
for i = 1:nlevels-1
    level = level + zinc;
    lines = contourGrid(lines, x1, y1, x2, y2, grid, level);
end

end

% gridKamb - calculates grid of density estimates from direction cosine
% data. The grid is normalized to the contour units.
function [grid] = gridKamb(x, ngrid, sigma, chb1)
[ndata,~] = size(x);
f = 2.0*(1.0 + ndata/(sigma*sigma));
zUnit = sqrt(ndata*(f*0.5-1.0)/(f*f));
dx = 2.0/(ngrid-1);
grid = zeros(ngrid, ngrid);
xg = -1.0;

for i = 1:ngrid
    yg = -1.0;
    for j = 1:ngrid
        y = sphereBProject(xg,yg,chb1);
        for k = 1:ndata
            d = dot(y,x(k,:));
            d = abs(d);
            grid(i,j) = grid(i,j) + exp(f*(d-1.0));
        end % k
        yg = yg + dx;
    end % j
    xg = xg + dx;
end % i
f = 1.0/zUnit;
grid = grid * f;
end

% sphereBProject - back projects cartesian coordinates of unit spherical
% projection to direction cosines.
function [dc] = sphereBProject(x, y, chb1)
r2 = (x*x)+(y*y);
if get(chb1,'Value') == 1 % Schmidt net
    f = sqrt(abs(2.0-r2));
    dc(3) = 1.0-r2;
elseif get(chb1,'Value') == 2 % Wülff net
    dc(3) = (1.0-r2)/(1.0+r2);
    f = 1.0+dc(3);
end
dc(1) = f*x;
dc(2) = f*y;
dc(3) = -dc(3); % Lower hemisphere
end

function [grid] = processGrid(grid, interp)
grid = grid';
[n, ~] = size(grid);
[x, y] = meshgrid(1:n);
[xi, yi] = meshgrid(1:interp:n);
zi = interp2(x,y,grid,xi,yi);
[ni, ~] = size(zi);
r = 0.5 * (ni-1);
r2 = r * r;
[xi, yi] = meshgrid(1:ni);
zi((xi - r - 1.0).^2 + (yi - r -1.0).^2 > r2) = NaN;
grid = zi;
end

% lineCircleInt - determine intersection parameters for line segment and
% circle. Adopted from Rankin 1989, p.220.
function [t1, t2, visible] = lineCircleInt(x1, y1, x2, y2, xc, yc, r)
visible = 0; % FALSE
t1 = 0.0;
t2 = 1.0;
dx = x2-x1;
dy = y2-y1;
dxc = x1-xc;
dyc = y1-yc;
a = dx*dxc + dy*dyc;
b = dx*dx + dy*dy;
c = dxc*dxc + dyc*dyc - r*r;
disc = a*a - b*c;
if ((disc > 0.0) && (abs(b) > 1e-9))
    d = sqrt(disc);
    t1 = (-a + d)/b;
    t2 = (-a - d)/b;
    if (t1 > t2)
        t = t1;
        t1 = t2;
        t2 = t;
    end
    visible = 1; % TRUE
end
end

% clipLineCircle - clip line segment to circle.
function [cx1, cy1, cx2, cy2, visible] = clipLineCircle(xc, yc, r, x1, y1, x2, y2)
cx1 = x1;
cy1 = y1;
cx2 = x2;
cy2 = y2;
visible = 0; % FALSE
if (((x1 < xc-r) && (x2 < xc-r)) || ((x1 > xc+r) && (x2 > xc+r)))
    return;
end
if (((y1 < yc-r) && (y2 < yc-r)) || ((y1 > yc+r) && (y2 > yc+r)))
    return;
end
[t1, t2, vis] = lineCircleInt(x1,y1,x2,y2,xc,yc,r);
if (vis == 0)
    return;
end
if ((t2 < 0.0) || (t1 > 1.0))
    visible = 0; % FALSE
    return;
end
if (t1 > 0.0)
    cx1 = x1 + (x2-x1) * t1;
    cy1 = y1 + (y2-y1) * t1;
end
if (t2 < 1.0)
    cx2 = x1 + (x2-x1) * t2;
    cy2 = y1 + (y2-y1) * t2;
end
visible = 1; % TRUE
end



% interpolate - determine linear interpolation point between two nodes.
function [x, y, bool] = interpolate(x1, y1, z1, x2, y2, z2, z0)
dz1 = z0-z1;
dz2 = z0-z2;
if (dz1 == 0.0)
    x = x1;
    y = y1;
    bool = 1;
elseif (dz2 == 0.0)
    x = x2;
    y = y2;
    bool = 0;
elseif (((dz1 > 0.0) && (dz2 > 0.0)) || ((dz1 < 0.0) && (dz2 < 0.0)))
    x = 0.0;
    y = 0.0;
    bool = 0; % FALSE
else
    dz = z2-z1;
    t = dz1/dz;
    x = x1 + (x2-x1) * t;
    y = y1 + (y2-y1) * t;
    bool = 1; % TRUE
end
end

% contourGrid - output one contour level by linear interpolation among grid nodes.
function [lines] = contourGrid(lines, x1, y1, x2, y2, grid, level)
[ng,mg] = size(grid);
dnx = (x2-x1)/(ng-1.0);
dny = (y2-y1)/(mg-1.0);
gy1 = y1;
nx = x1;
for i = 1:ng-1
    ny = gy1;
    nxp = nx + dnx;
    for j = 1:mg-1
        nyp = ny + dny;
        z1 = grid(i,j);
        z2 = grid(i+1,j);
        z3 = grid(i+1,j+1);
        z4 = grid(i,j+1);
        found = 0;
        [x1,y1,bool] = interpolate(nx,ny,z1,nxp,ny,z2,level);
        if bool
            found = found+1;
        end
        [x2,y2,bool] = interpolate(nxp,ny,z2,nxp,nyp,z3,level);
        if bool
            found = found+2;
        end
        [x3,y3,bool] = interpolate(nxp,nyp,z3,nx,nyp,z4,level);
        if bool
            found = found+4;
        end
        [x4,y4,bool] = interpolate(nx,nyp,z4,nx,ny,z1,level);
        if bool
            found = found+8;
        end
        switch (found)
            case  3
                lines = cLineOut(lines,x1,y1,x2,y2);
            case  5
                lines = cLineOut(lines,x1,y1,x3,y3);
            case  9
                lines = cLineOut(lines,x1,y1,x4,y4);
            case  6
                lines = cLineOut(lines,x2,y2,x3,y3);
            case 10
                lines = cLineOut(lines,x2,y2,x4,y4);
            case 12
                lines = cLineOut(lines,x3,y3,x4,y4);
            case 15
                d1 = sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
                d2 = sqrt((x2-x3)*(x2-x3) + (y2-y3)*(y2-y3));
                d3 = sqrt((x3-x4)*(x3-x4) + (y3-y4)*(y3-y4));
                d4 = sqrt((x4-x1)*(x4-x1) + (y4-y1)*(y4-y1));
                if ((d1+d3) < (d2+d4))
                    lines = cLineOut(lines,x1,y1,x2,y2);
                    lines = cLineOut(lines,x3,y3,x4,y4);
                else
                    lines = cLineOut(lines,x2,y2,x3,y3);
                    lines = cLineOut(lines,x1,y1,x4,y4);
                end
        end % switch
        ny = nyp;
    end % j
    nx = nxp;
end % i
end

% cLineOut - output a line segment clipped to current projection.
function [lines] = cLineOut(lines, x1, y1, x2, y2)
[cx1, cy1, cx2, cy2, visible] = clipLineCircle(0.0, 0.0, 1.0, x1, y1, x2, y2);
if (visible)
    lines = [lines; [cx1,cy1,cx2,cy2]];
end
end