function [Data,Revrec]=Rotator(CoreOr, Data)
%
% function Rotator: Apply several rotations to the dataset to calculate cartesian
% coordinates in the geographic reference frame.
% input:    - CoreOr: core orientation (DipDir, Dip, reverse position, misorientation angle)
%           - Data: directional cosines of data onto which rotations should be applied.
% output:   - Data: set of rotated points in cartesian coordinates
%           - Revrec: array recording if points had z > 0 after rotation.
%           Important for ellipses segmentation during plotting.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This file is part of TOMOFAB. Copyright (C) 2018-2020  Benoit Petri
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

Revrec=zeros(size(Data,1),1);

CoreDeg = [CoreOr(1) CoreOr(2)];
RevPosition = CoreOr(3);
MisAngle = CoreOr(4);


%% Change of coordinates system
CoreDeg = -CoreDeg;
MisAngle = -MisAngle;

for i=1:size(Data,1)
    DataCart=[Data(i,1) Data(i,2) Data(i,3)];
    
    %%
    %% Rotation phase 1: correction for acquisition misorientation (core centering and bottom down reorientation)
    %%
    
    %%
    %% Rotation 1: correction for sample misorientation: around Z, amount = misorientation angle
    %%
    
    thetaR1 = -MisAngle; % Rotation angle
    thetaR1 = -pi*(thetaR1)/180; % transformation into rad
    R1= ([cos(thetaR1) -sin(thetaR1) 0 ; sin(thetaR1) cos(thetaR1) 0 ; 0 0 1]); % Rotation matrix
    
    DataCartT1 = R1*DataCart';

    
    
    %%
    %% Rotation 2: correction for bottom up acquisition: for reversed samples, around X, amount = 180�
    %%
    
    if RevPosition == 1;
        u2 = [1 0 0]; % Unitary vector of the rotation axis
        thetaR2 = -180; % Rotation angle
        thetaR2 = -pi*(thetaR2)/180; % transformation into rad
        c2 = cos(thetaR2);
        s2 = sin(thetaR2);
        R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
        
        DataCartT2 = R2*DataCartT1;
        DataCartT2 = -DataCartT2;
    else
        DataCartT2 = DataCartT1;
    end
    
    
    %%
    %% Rotation phase 2: core and axes reorientation in geographic reference frame
    %%
    
    %%
    %% Rotation 3: Strike correction: along the z axis, amount = dip direction
    %%
    
    
    thetaR3 = -CoreDeg(1); % Rotation angle
    thetaR3 = -pi*(thetaR3)/180; % transformation into rad
    R3= ([cos(thetaR3) -sin(thetaR3) 0 ; sin(thetaR3) cos(thetaR3) 0 ; 0 0 1]); % Rotation matrix

    DataCartT3 = R3*DataCartT2;
    
    
    %%
    %% Rotation 4: Dip correction: along the azimuth, amount = dip
    %%
    
    [u4(1),u4(2),u4(3)] = sph2cart(pi*(CoreDeg(1))/180, 0, 1); % Unitary vector of the rotation axis
    thetaR4 = -CoreDeg(2); % Rotation angle
    thetaR4 = -pi*(90-thetaR4)/180; % transformation into rad
    c4 = cos(thetaR4);
    s4 = sin(thetaR4);
    R4 = ([u4(1)^2*(1-c4)+c4 u4(1)*u4(2)*(1-c4)+u4(3)*s4 u4(1)*u4(3)*(1-c4)-u4(2)*s4 ; u4(1)*u4(2)*(1-c4)-u4(3)*s4 u4(2)^2*(1-c4)+c4 u4(2)*u4(3)*(1-c4)+u4(1)*s4 ; u4(1)*u4(3)*(1-c4)+u4(2)*s4 u4(2)*u4(3)*(1-c4)-u4(1)*s4 u4(3)^2*(1-c4)+c4]); % Rotation matrix
    DataCartT4 = R4*DataCartT3;
    
       
    if DataCartT4(3)>0 % Correction for upper hemisphere data, noted -1 in Revrec
        DataCartT4 = -DataCartT4;
        Revrec(i)=-1;
    end
    
    Data(i,1)=round(DataCartT4(1),6);
    Data(i,2)=round(DataCartT4(2),6);
    Data(i,3)=round(DataCartT4(3),6);

end

return
