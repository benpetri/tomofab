function [V1, V2, V3]=ConfidencePlotHeJe(V1, V2, V3, chb1, chb12, chb13, chb14)
%
% function ConfidencePlotHeJe: Rotate confidence ellipses calculated using
% Hext or Jelinek methods, where ellipses need to be rotated to align their
% axis with V1-V2, V1-V3 and V2-V3 planes, and ask for plotting them.
% input:    - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Set of UIcontrol
% output:   - V1, V2, V3: structures containing the selected set of 
%           directional data.
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


% Rotation 1: V2 Ellipse to North
u2 = [1 0 0]; % Unitary vector of the rotation axis
thetaR2 = 90; % Rotation angle
thetaR2 = -pi*(thetaR2)/180; % transformation into rad
c2 = cos(thetaR2);
s2 = sin(thetaR2);
R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix

for i=1:size(V2.confell,1)
    Data=[V2.confell(i,1) V2.confell(i,2) V2.confell(i,3)];
    DataT = R2*Data';
    V2.confell(i,1)=DataT(1);
    V2.confell(i,2)=DataT(2);
    V2.confell(i,3)=DataT(3);
end


% %% Rotation 2: V2 Ellipse to East
u2 = [0 1 0]; % Unitary vector of the rotation axis
thetaR2 = -90; % Rotation angle
thetaR2 = -pi*(thetaR2)/180; % transformation into rad
c2 = cos(thetaR2);
s2 = sin(thetaR2);
R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix

for i=1:size(V3.confell,1)
    Data=[V3.confell(i,1) V3.confell(i,2) V3.confell(i,3)];
    DataT = R2*Data';
    V3.confell(i,1)=DataT(1);
    V3.confell(i,2)=DataT(2);
    V3.confell(i,3)=DataT(3);
end


%%% Rotation 3 sets V1 at its appropriate place
[u3(1),u3(2),u3(3)] = sph2cart(pi*(-V1.meandeg(1))/180, 0, 1); % Unitary vector of the rotation axis
thetaR3 = V1.meandeg(2); % Rotation angle
thetaR3 = -pi*(90-thetaR3)/180; % transformation into rad
c3 = cos(thetaR3);
s3 = sin(thetaR3);
R3 = ([u3(1)^2*(1-c3)+c3 u3(1)*u3(2)*(1-c3)+u3(3)*s3 u3(1)*u3(3)*(1-c3)-u3(2)*s3 ; u3(1)*u3(2)*(1-c3)-u3(3)*s3 u3(2)^2*(1-c3)+c3 u3(2)*u3(3)*(1-c3)+u3(1)*s3 ; u3(1)*u3(3)*(1-c3)+u3(2)*s3 u3(2)*u3(3)*(1-c3)-u3(1)*s3 u3(3)^2*(1-c3)+c3]); % Rotation matrix

for i=1:size(V1.confell,1)
    DataV1=[V1.confell(i,1) V1.confell(i,2) V1.confell(i,3)];
    DataV1 = R3*DataV1';
    V1.confell(i,1)=DataV1(1);
    V1.confell(i,2)=DataV1(2);
    V1.confell(i,3)=DataV1(3);
end
for i=1:size(V2.confell,1)
    DataV2=[V2.confell(i,1) V2.confell(i,2) V2.confell(i,3)];
    DataV2 = R3*DataV2';
    V2.confell(i,1)=DataV2(1);
    V2.confell(i,2)=DataV2(2);
    V2.confell(i,3)=DataV2(3);
end
for i=1:size(V3.confell,1)
    DataV3=[V3.confell(i,1) V3.confell(i,2) V3.confell(i,3)];
    DataV3 = R3*DataV3';
    V3.confell(i,1)=DataV3(1);
    V3.confell(i,2)=DataV3(2);
    V3.confell(i,3)=DataV3(3);
end
marker3=R3*[1 0 0]'; %Marker to quantify rotation angle around V1 axis to align V2 and V3

%%% Rotation 4 sets V2 and V3 at its appropriate place
u4=V1.meancart;

thetaR4 = atan2d(norm(cross(V3.meancart,marker3)),dot(V3.meancart,marker3));
sens=atan2d(cross(V3.meancart,marker3),dot(V3.meancart,marker3));
if sens(3)>0 % Take the sens of rotation into account
    thetaR4 = -pi*(thetaR4)/180; % transformation into rad
else
    thetaR4 = pi*(thetaR4)/180; % transformation into rad
end
c4 = cos(thetaR4);
s4 = sin(thetaR4);
R4 = ([u4(1)^2*(1-c4)+c4 u4(1)*u4(2)*(1-c4)+u4(3)*s4 u4(1)*u4(3)*(1-c4)-u4(2)*s4 ; u4(1)*u4(2)*(1-c4)-u4(3)*s4 u4(2)^2*(1-c4)+c4 u4(2)*u4(3)*(1-c4)+u4(1)*s4 ; u4(1)*u4(3)*(1-c4)+u4(2)*s4 u4(2)*u4(3)*(1-c4)-u4(1)*s4 u4(3)^2*(1-c4)+c4]); % Rotation matrix

for i=1:size(V1.confell,1)
    DataV1=[V1.confell(i,1) V1.confell(i,2) V1.confell(i,3)];
    DataV1 = R4*DataV1';
    V1.confell(i,1)=DataV1(1);
    V1.confell(i,2)=DataV1(2);
    V1.confell(i,3)=DataV1(3);
end
for i=1:size(V2.confell,1)
    DataV2=[V2.confell(i,1) V2.confell(i,2) V2.confell(i,3)];
    DataV2 = R4*DataV2';
    V2.confell(i,1)=DataV2(1);
    V2.confell(i,2)=DataV2(2);
    V2.confell(i,3)=DataV2(3);
end
for i=1:size(V3.confell,1)
    DataV3=[V3.confell(i,1) V3.confell(i,2) V3.confell(i,3)];
    DataV3 = R4*DataV3';
    V3.confell(i,1)=DataV3(1);
    V3.confell(i,2)=DataV3(2);
    V3.confell(i,3)=DataV3(3);
end

% Plot requested ellipses
if get(chb12,'Value')==1
    [V1.confell]=ConfidencePlot(V1.confell,[0 90 0 0],'r',chb1);
end
if get(chb13,'Value')==1
    [V2.confell]=ConfidencePlot(V2.confell,[0 90 0 0],[0.127 0.746 0.127],chb1);
end
if get(chb14,'Value')==1
    [V3.confell]=ConfidencePlot(V3.confell,[0 90 0 0],'b',chb1);
end


end

