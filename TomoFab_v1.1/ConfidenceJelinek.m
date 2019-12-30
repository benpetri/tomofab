function [V1,V2,V3,Vtot,params]=ConfidenceJelinek(V1, V2, V3, Vtot, params, Text8, Text23, Text24, Text25, chb1, chb12, chb13, chb14)
%
% function ConfidenceJelinek: Calculates confidence angles and ellipses 
% following the method of Jelinek (1978) using 2nd order tensor analysis.
% See Tauxe (2002) for synthesis.
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
% This function is inspired from jelinekstat (Montoya-Araque and Suarez-Burgoa, 2018)
% references:
% - Jelinek, V., 1978. Statistical processing of anisotropy of
% magnetic susceptibility measured on groups of specimens. Stud. Geophys.
% Geod. 22, 50-62. https://doi.org/10.1007/BF01613632
% - Montoya-Araque, E.A., Suarez-Burgoa, L.O., 2018. Software de aplicación
% en Python 3 para el cálculo de la estadística de tensores de segundo orden
% de Jelinek en datos de anisotropía de susceptibilidad magnética. 
% Boletín Ciencias la Tierra 49–58. doi:10.15446/rbct.n44.70973
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

[Tevec,evaltmp]=eig(Vtot.fabtens); % The method of Jelinek needs the use of normalized tensor to avoid variations with axes lengths variations
Teval=[evaltmp(3,3) evaltmp(2,2) evaltmp(1,1)];

% eq. 21 of Jelinek (1978), eq. 5.27 of Tauxe (2002)
G = [Tevec(1,1)^2, Tevec(2,1)^2, Tevec(3,1)^2, 2*Tevec(1,1)*Tevec(2,1), 2*Tevec(2,1)*Tevec(3,1), 2*Tevec(3,1)*Tevec(1,1);
    Tevec(1,2)^2, Tevec(2,2)^2, Tevec(3,2)^2, 2*Tevec(1,2)*Tevec(2,2), 2*Tevec(2,2)*Tevec(3,2), 2*Tevec(3,2)*Tevec(1,2);
    Tevec(1,3)^2, Tevec(2,3)^2, Tevec(3,3)^2, 2*Tevec(1,3)*Tevec(2,3), 2*Tevec(2,3)*Tevec(3,3), 2*Tevec(3,3)*Tevec(1,3);
    Tevec(1,1)*Tevec(1,2), Tevec(2,1)*Tevec(2,2), Tevec(3,1)*Tevec(3,2), Tevec(1,1)*Tevec(2,2)+Tevec(2,1)*Tevec(1,2), Tevec(2,1)*Tevec(3,2)+Tevec(3,1)*Tevec(2,2), Tevec(3,1)*Tevec(1,2)+Tevec(1,1)*Tevec(3,2);
    Tevec(1,2)*Tevec(1,3), Tevec(2,2)*Tevec(2,3), Tevec(3,2)*Tevec(3,3), Tevec(1,2)*Tevec(2,3)+Tevec(2,2)*Tevec(1,3), Tevec(2,2)*Tevec(3,3)+Tevec(3,2)*Tevec(2,3), Tevec(3,2)*Tevec(1,3)+Tevec(1,2)*Tevec(3,3);
    Tevec(1,3)*Tevec(1,1), Tevec(2,3)*Tevec(2,1), Tevec(3,3)*Tevec(3,1), Tevec(1,3)*Tevec(2,1)+Tevec(2,3)*Tevec(1,1), Tevec(2,3)*Tevec(3,1)+Tevec(3,3)*Tevec(2,1), Tevec(3,3)*Tevec(1,1)+Tevec(1,3)*Tevec(3,1)];


G = (size(V1.cosine,1) - 1) / size(V1.cosine,1) * G; % Normalization by the number of ellipsoids
covMtx=cov(G); % G covariance matrix calculation


pCovMtx = G*(covMtx*G'); % eq. 27 of Jelinek (1978), eq. 5.26 of Tauxe (2002)


i=1; j=2; k=3; % eq. 20 of Jelinek (1978), eq. 5.28 of Tauxe (2002)
W1=[pCovMtx(3+i,3+i)/(Teval(i)-Teval(j))^2, pCovMtx(3+i,3+k)/((Teval(i)-Teval(j))*(Teval(i)-Teval(k)));
    pCovMtx(3+i,3+k)/((Teval(i)-Teval(j))*(Teval(i)-Teval(k))), pCovMtx(3+k,3+k)/(Teval(i)-Teval(k))^2];

i=2; j=3; k=1;
W2=[pCovMtx(3+i,3+i)/(Teval(i)-Teval(j))^2, pCovMtx(3+i,3+k)/((Teval(i)-Teval(j))*(Teval(i)-Teval(k)));
    pCovMtx(3+i,3+k)/((Teval(i)-Teval(j))*(Teval(i)-Teval(k))), pCovMtx(3+k,3+k)/(Teval(i)-Teval(k))^2];

i=3; j=1; k=2;
W3=[pCovMtx(3+i,3+i)/(Teval(i)-Teval(j))^2, pCovMtx(3+i,3+k)/((Teval(i)-Teval(j))*(Teval(i)-Teval(k)));
    pCovMtx(3+i,3+k)/((Teval(i)-Teval(j))*(Teval(i)-Teval(k))), pCovMtx(3+k,3+k)/(Teval(i)-Teval(k))^2];

[eigvecW1, eigvalW1]=eig(W1);
[eigvecW2, eigvalW2]=eig(W2);
[eigvecW3, eigvalW3]=eig(W3);

if size(V1.cosine,1)-2>0
    [stat] = Fstatistics(size(V1.cosine,1)-2);  % Seek for the appropriate value in the table stored in Fstatistics (F table for aplha = 0.05)
else
    set(Text8, 'string', 'Jelinek statistics impossible to calculate for less than 3 ellipsoids', 'Foregroundcolor','r') % Refresh GUI
    return
end


T2 = stat*2*(size(V1.cosine,1)-1)/(size(V1.cosine,1)*(size(V1.cosine,1)-2));

% eq. 38 of Jelinek (1978), eq.  5.29 of Tauxe (2002)
anglesV1(1)=atand(sqrt(T2*eigvalW1(1,1)));
anglesV1(2)=atand(sqrt(T2*eigvalW1(2,2)));
anglesV1(3)=atand(eigvecW1(2,1)/eigvecW1(1,1));

anglesV2(1)=atand(sqrt(T2*eigvalW2(1,1)));
anglesV2(2)=atand(sqrt(T2*eigvalW2(2,2)));
anglesV2(3)=atand(eigvecW2(2,1)/eigvecW2(1,1));

anglesV3(1)=atand(sqrt(T2*eigvalW3(1,1)));
anglesV3(2)=atand(sqrt(T2*eigvalW3(2,2)));
anglesV3(3)=atand(eigvecW3(2,1)/eigvecW3(1,1));

if anglesV1(3)>-45 && anglesV1(3)<45 % Save the angles at their right place
    V1.confang(1)=anglesV1(1);
    V1.confang(2)=anglesV1(2);
else
    V1.confang(1)=anglesV1(2);
    V1.confang(2)=anglesV1(1);
end

if anglesV2(3)>-45 && anglesV2(3)<45
    V2.confang(1)=anglesV2(2);
    V2.confang(2)=anglesV2(1);
else
    V2.confang(1)=anglesV2(1);
    V2.confang(2)=anglesV2(2);
end

if anglesV3(3)>-45 && anglesV3(3)<45
    V3.confang(1)=anglesV3(1);
    V3.confang(2)=anglesV3(2);
else
    V3.confang(1)=anglesV3(2);
    V3.confang(2)=anglesV3(1);
end


%%
%% Now we can plot the ellipses
%%

if get(chb1,'value')==1 % Plot planes linking mean directions
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

% Meshgrid for a sphere
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
% Meshgrid for the cone
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

% Calculation of the difference between the sphere and the cone = 0 at the intercept
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

[V1, V2, V3] = ConfidencePlotHeJe(V1, V2, V3, chb1, chb12, chb13, chb14);  % Send the dataset to be rotated, centered and displaied

set(Text23, 'string', ['E12: ' num2str(round(V1.confang(1),1)) '    E13: ' num2str(round(V1.confang(2),1)) ]) % Refresh GUI
set(Text24, 'string', ['E21: ' num2str(round(V2.confang(1),1)) '    E23: ' num2str(round(V2.confang(2),1)) ]) % Refresh GUI
set(Text25, 'string', ['E31: ' num2str(round(V3.confang(1),1)) '    E32: ' num2str(round(V3.confang(2),1)) ]) % Refresh GUI


set(Text8, 'string', 'Jelinek confidence ellipse calculated', 'Foregroundcolor','k') % Refresh GUI

end

