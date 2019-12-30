function [a95,Ell] = ConfidenceFisher(Points)
%
% function ConfidenceFisher: Calulates the opening angle of a confidence
% cone around mean direction calculated by vector analysis following Fisher
% (1953). See Tauxe (2002) for synthesis.
% input:    - Points: set of points to analyse, in cartesian coordinates
% output:   - a95: half opening angle of the confidence circle at a 95%
%              level of conficense
%           - ak95: k-parameter of the Fisher statistics, indicates
%           clustered or scattered distributions
% references:
% - Fisher, R., 1953. Dispersion on a sphere. Proc. R. Soc.
% London. Ser. A. Math. Phys. Sci. 217, 295 LP-305.
% - Tauxe, L., 2002. Paleomagnetic principles and practice. Kluwer, Dodrecht.
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

sumx=0;
sumy=0;
sumz=0;
for i=1:size(Points,1)
    sumx=sumx+Points(i,1);
    sumy=sumy+Points(i,2);
    sumz=sumz+Points(i,3);
end
R=sqrt(sumx^2+sumy^2+sumz^2); % Calculate the R parameter, eq 4.2 of Tauxe (2002)
N=size(Points,1); % Number of points
p=0.05; % 95% level of confidence
a95=acosd(1-(N-R)/R*((1/p)^(1/(N-1))-1)); % Calculate the opening half angle, eq 4.4 of Tauxe (2002)
% ak95=(N-1)/(N-R); %% Estimate the degree of scatter, 1 = high scatter, inf = tight cluster

r=sind(a95); % Calculates the circle radius
th = linspace(0,2*pi,100);
xunit = r .* cos(th);
yunit = r .* sin(th);
zpos=cosd(a95); % Calculates the z position of the circle
zunit=-zpos*ones(size(th)); 
Ell=[xunit' yunit' zunit']; % Put everything together

end

