function [V1,V2,V3,Vtot,params]=ConfidenceHext(V1, V2, V3, Vtot, params, Text8, Text23, Text24, Text25, chb1, chb12, chb13, chb14)
%
% function ConfidenceHext: Calculates confidence angles and ellipses using
% Hext (1953) 2nd order tensor statistics. See Tauxe (2002) for synthesis.
% input:	- V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
%           - Set of UIcontrol
% output:	- V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
% This function is inspired from pmag1.0 (Tauxe, 2002)
% reference:
% - Hext, G.R., 1963. The Estimation of Second-Order Tensors, 
% with Related Tests and Designs. Biometrika 50, 353-373.
% doi:10.2307/2333905
% - Tauxe, L., 2002. Paleomagnetic principles and practice. Kluwer, Dodrecht.
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

% Create an array contaning 6 elements (eq. 5.4. of Tauxe, 2002) related to
% the A design matrix (eq 5.5 of Tauxe, 2002)
K=[Vtot.fabtens(1,1);
    Vtot.fabtens(2,2);
    Vtot.fabtens(3,3);
    1/2*(Vtot.fabtens(1,1)+Vtot.fabtens(2,2))+Vtot.fabtens(1,2);
    1/2*(Vtot.fabtens(2,2)+Vtot.fabtens(3,3))+Vtot.fabtens(2,3);
    1/2*(Vtot.fabtens(1,1)+Vtot.fabtens(3,3))+Vtot.fabtens(1,3)];

avK=zeros(1,1);
for j=1:6
    avK=avK+K(j);
end
avK=avK/size(V1.cosine,1); % Calculate and normalize the K mean value

s0=0;
for i=1:6
    s0=s0+(K(i)-avK)^2; % eq. 5.20 and 5.14 of Tauxe (2002)
end

%% Calculate sigma, eq 5.15 of Tauxe (2002)
nf=(size(V1.cosine,1)-1)*6; % Here nf considers the number of samples (ellipsoids) and their measurements (following Hext scheme, with 6 elements per sample)
sigma=sqrt(s0/nf);
if nf>0
    [F]=Fstatistics(nf); % Seek for the appropriate value in the table stored in Fstatistics (F table for aplha = 0.05)
else
    set(Text8, 'string', 'Hext statistics impossible to calculate for less than 2 ellipsoids', 'Foregroundcolor','r')
    return
end
f=sqrt(2*F); % Using F values from a Fisher statistics table saved in Fstatistics

% eq 5.21 of Tauxe (2002)
EP1=atand((f*sigma)/(2*(Vtot.fteigval(1)-Vtot.fteigval(2))));
EP2=atand((f*sigma)/(2*(Vtot.fteigval(2)-Vtot.fteigval(3))));
EP3=atand((f*sigma)/(2*(Vtot.fteigval(1)-Vtot.fteigval(3))));

V1.confang=[]; V2.confang=[]; V3.confang=[]; % Save confidence angles where they should
V1.confang(1)=EP1;
V1.confang(2)=EP3;
V2.confang(1)=EP1;
V2.confang(2)=EP2;
V3.confang(1)=EP3;
V3.confang(2)=EP2;


%%
%% Now we can plot the ellipses
%%

% plot the great circles related to opening angles
if get(chb1,'value')==1
    [x,y]=GCSchmidt(Vtot.plane12(1),Vtot.plane12(2));
elseif get(chb1,'value')==2
    [x,y]=GCWulff(Vtot.plane12(1),Vtot.plane12(2));
end
plot(x,y,'--k');
clearvars x y
if get(chb1,'value')==1
    [x,y]=GCSchmidt(Vtot.plane13(1),Vtot.plane13(2));
elseif get(chb1,'value')==2
    [x,y]=GCWulff(Vtot.plane13(1),Vtot.plane13(2));
end
plot(x,y,'--k');
clearvars x y
if get(chb1,'value')==1
    [x,y]=GCSchmidt(Vtot.plane23(1),Vtot.plane23(2));
elseif get(chb1,'value')==2
    [x,y]=GCWulff(Vtot.plane23(1),Vtot.plane23(2));
end
plot(x,y,'--k');
clearvars x y

%%
%% Case 0: Creating marerial
%%

%% Meshgrid for a sphere
Xsph=linspace(-1,1,200);
Ysph=linspace(-1,1,200);
[Xsph,Ysph]=meshgrid(Xsph,Ysph);
Zsph=zeros(size(Xsph));
for i=1:size(Xsph,2)
    for j=1:size(Ysph,2)
        if sqrt(Xsph(i,j)^2+Ysph(i,j)^2)<=1
            Zsph(i,j)=-sqrt(1-Xsph(i,j)^2-Ysph(i,j)^2);
        end
    end
end
%% Meshgrid for the cone
Xcone=linspace(-1,1,200);
Ycone=linspace(-1,1,200);
[Xcone,Ycone]=meshgrid(Xcone,Ycone);



%%
%% Case 1: V1 confidence ellipse
%%

Zcone=-ones(size(Xcone));
for i=1:size(Xcone,2) % Calculates Z for a cone with alpha (x-directed) and beta (y-directed) opening half-angles
    for j=1:size(Ycone,2)
        if sqrt(Xcone(i,j)^2+Ycone(i,j)^2)<=1
            Zcone(i,j)=-sqrt(((Xcone(i,j)^2/(tand(V1.confang(2)))^2)+(Ycone(i,j)^2/(tand(V1.confang(1)))^2)));
        end
    end
end

%% Calculation of the difference between the sphere and the cone = 0 at the intercept
Zdiff=Zcone-Zsph;

C=contours(Xcone,Ycone,Zdiff, [0 0]); %% Extracting the x and y coordinates where Zdiff is null
xL = C(1, 2:end);
yL = C(2, 2:end);

zL=zeros(size(xL));
for i=1:size(xL,2) %% Retreive Z coordinates using the equation of a sphere
    zL(i)=-sqrt(1-xL(i)^2-yL(i)^2);
end

V1.confell=[xL' yL' zL']; % Save the points to confell


%%
%% Case 2: V2 confidence ellipse
%%

Zcone=-ones(size(Xcone));
for i=1:size(Xcone,2) % Calculates Z for a cone with alpha (x-directed) and beta (y-directed) opening half-angles
    for j=1:size(Ycone,2)
        if sqrt(Xcone(i,j)^2+Ycone(i,j)^2)<=1
            Zcone(i,j)=-sqrt(((Xcone(i,j)^2/(tand(V2.confang(2)))^2)+(Ycone(i,j)^2/(tand(V2.confang(1)))^2)));
        end
    end
end

%% Calculation of the difference between the sphere and the cone = 0 at the intercept
Zdiff=Zcone-Zsph;

C=contours(Xcone,Ycone,Zdiff, [0 0]); %% Extracting the x and y coordinates where Zdiff is null
xL = C(1, 2:end);
yL = C(2, 2:end);

zL=zeros(size(xL));
for i=1:size(xL,2) %% Retreive Z coordinates using the equation of a sphere
    zL(i)=-sqrt(1-xL(i)^2-yL(i)^2);
end

V2.confell=[xL' yL' zL']; % Save the points to confell



%%
%% Case 3: V3 confidence ellipse
%%

Zcone=-ones(size(Xcone));
for i=1:size(Xcone,2) % Calculates Z for a cone with alpha (x-directed) and beta (y-directed) opening half-angles
    for j=1:size(Ycone,2)
        if sqrt(Xcone(i,j)^2+Ycone(i,j)^2)<=1
            Zcone(i,j)=-sqrt(((Xcone(i,j)^2/(tand(V3.confang(1)))^2)+(Ycone(i,j)^2/(tand(V3.confang(2)))^2)));
        end
    end
end

%% Calculation of the difference between the sphere and the cone = 0 at the intercept
Zdiff=Zcone-Zsph;

C=contours(Xcone,Ycone,Zdiff, [0 0]); %% Extracting the x and y coordinates where Zdiff is null
xL = C(1, 2:end);
yL = C(2, 2:end);

zL=zeros(size(xL));
for i=1:size(xL,2) %% Retreive Z coordinates using the equation of a sphere
    zL(i)=-sqrt(1-xL(i)^2-yL(i)^2);
end

V3.confell=[xL' yL' zL']; % Save the points to confell

[V1,V2,V3]=ConfidencePlotHeJe(V1, V2, V3, chb1, chb12, chb13, chb14);  % Send the dataset to be rotated, centered and displaied

set(Text23, 'string', ['E12 = E21:   ' num2str(round(V1.confang(1),1))]) % Refresh GUI
set(Text24, 'string', ['E13 = E31:   ' num2str(round(V1.confang(2),1))]) % Refresh GUI
set(Text25, 'string', ['E23 = E32:   ' num2str(round(V2.confang(2),1))]) % Refresh GUI


set(Text8, 'string', 'Hext confidence ellipse calculated', 'Foregroundcolor','k')

end

