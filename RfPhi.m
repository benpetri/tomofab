function RfPhi(V1,V2,V3,Vtot,Text8,Text27,weight_option)
%
% function RfPhi: performs a Rf/Phi analysis following the method of Ramsay
% (1967) lately detailled by Lisle (1985) evaluating the finite strain
% (Rf), the initial grain aspect ratio (Ri), and the initial long-axis
% preferred orientation angle with respect to the mean V1 or V2 orientation
% (Theta). The function calculates the intersection of each ellipsoid with
% the XZ and YZ structural planes resulting in a set of ellipses on wich
% the Rf/Phi analysis is performed using ellipse aspect ratio (Rf) and
% ellipse long-axis misorientation (Phi) with respect to mean V1 (on XZ) or
% mean V2 (on YZ).
%
% input:	- V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters.
%           - Set of UIcontrol
%           - weight_option: 0 for standard Rf/Phi, 1 for weighted Rf/Phi.
% output:	- a series of Rf/Phi routine graphs made along the XZ (V1-V3)
%           and YZ (V2-V3) structural planes that should be first compiled.
% This function integrates parts of PolyLX routines (Lexa, 2003).
% references:
% - Lexa, O., 2003. Numerical Approaches in Structural and Micro structural 
% Analyses. Unpublished PhD thesis, Charles University, Prague.
% - Lisle, R. J., 1985. Geological strain analysis: A manual for the Rf/Phi
% technique. Pergamon, Oxford.
% - Ramsay, J. G., 1967. Fracturing and folding of rocks. McGraw-Hill, New
% York.
%
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


if Vtot.fabtens==0 % Security if no fabric tensor analysis was run yet, it is impossible to perform a RfPhi analysis
    set(Text8, 'string', 'No Rf-Phi analysis can be performed. Run a fabric analysis first, please.', 'Foregroundcolor','r') % Update text box
    return
end

if size(V1.cosine,1)>1
    %% Vamos!
    set(Text27,'string','BUSY','BackgroundColor',[1 0.2 0]); % Let's say we are busy working.
    drawnow

    V1XZ=struct('cosine',zeros(size(V1.cosine,1),3),'length',zeros(size(V1.cosine,1)));
    V2XZ=struct('cosine',zeros(size(V1.cosine,1),3),'length',zeros(size(V1.cosine,1)));
    V1YZ=struct('cosine',zeros(size(V1.cosine,1),3),'length',zeros(size(V1.cosine,1)));
    V2YZ=struct('cosine',zeros(size(V1.cosine,1),3),'length',zeros(size(V1.cosine,1)));

    %%
    %% Let's first calculate the ellipses on XZ and YZ structural planes
    %%
    close(figure(2))
    figure(2)

    for ii=1:size(V1.cosine,1)

        resol=100; % resolution of the mesh that will estimate the ellipse resulting from the intersectio of each ellipsoid with the structural plane of interest.

        [xell,yell,zell]=ellipsoid(0,0,0,V2.length(ii),V1.length(ii),V3.length(ii),resol); % Equation of the ellipsoid pointing to the N (X-Y are reversed)
        

        %% Rotation of all points to align the ellipsoid with the 3 principal vectors
        v1coord=Cart2Deg(V1.cosine(ii,:));
        % Rotation 1: align V1 - azimuth
        u1 = [0 0 1]; % Unitary vector of the rotation axis
        thetaR1=v1coord(1);
        thetaR1 = pi*(thetaR1)/180; % transformation into rad
        c1 = cos(thetaR1);
        s1 = sin(thetaR1);
        R1 = ([u1(1)^2*(1-c1)+c1 u1(1)*u1(2)*(1-c1)+u1(3)*s1 u1(1)*u1(3)*(1-c1)-u1(2)*s1 ; u1(1)*u1(2)*(1-c1)-u1(3)*s1 u1(2)^2*(1-c1)+c1 u1(2)*u1(3)*(1-c1)+u1(1)*s1 ; u1(1)*u1(3)*(1-c1)+u1(2)*s1 u1(2)*u1(3)*(1-c1)-u1(1)*s1 u1(3)^2*(1-c1)+c1]); % Rotation matrix        for i=1:size(xell,1)
        for i=1:size(xell,1)
            for j=1:size(xell,2)
                DataCart = R1*[xell(i,j) yell(i,j) zell(i,j)]';
                xell(i,j)=DataCart(1);
                yell(i,j)=DataCart(2);
                zell(i,j)=DataCart(3);
            end
        end
        % Rotation 2: align V1 - dip angle
        u2 = R1*[1 0 0]'; % Unitary vector of the rotation axis, horizontal but perpendicular to V1 strike, right-hand side of the original ellipsoid. Should be rotated as the rest.
        thetaR2=v1coord(2);
        thetaR2 = pi*(thetaR2)/180; % transformation into rad
        c2 = cos(thetaR2);
        s2 = sin(thetaR2);
        R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
        for i=1:size(xell,1)
            for j=1:size(xell,2)
                DataCart = R2*[xell(i,j) yell(i,j) zell(i,j)]';
                xell(i,j)=DataCart(1);
                yell(i,j)=DataCart(2);
                zell(i,j)=DataCart(3);
            end
        end
        %% BUG HERE, SET R3 properly
        % Rotation 3: align V2-V3 by rotation around V1
        u3 = V1.cosine(ii,:); % Unitary vector of the rotation axis
        thetaR3=atan2d(norm(cross(u2,V2.cosine(ii,:))), dot(u2,V2.cosine(ii,:))); % Rotation angle atan2(norm(cross(u,v)), dot(u,v))
        thetaR3 = -pi*(thetaR3)/180; % transformation into rad
        c3 = cos(thetaR3);
        s3 = sin(thetaR3);
        R3 = ([u3(1)^2*(1-c3)+c3 u3(1)*u3(2)*(1-c3)+u3(3)*s3 u3(1)*u3(3)*(1-c3)-u3(2)*s3 ; u3(1)*u3(2)*(1-c3)-u3(3)*s3 u3(2)^2*(1-c3)+c3 u3(2)*u3(3)*(1-c3)+u3(1)*s3 ; u3(1)*u3(3)*(1-c3)+u3(2)*s3 u3(2)*u3(3)*(1-c3)-u3(1)*s3 u3(3)^2*(1-c3)+c3]); % Rotation matrix
        for i=1:size(xell,1)
            for j=1:size(xell,2)
                DataCart = R3*[xell(i,j) yell(i,j) zell(i,j)]';
                xell(i,j)=DataCart(1);
                yell(i,j)=DataCart(2);
                zell(i,j)=DataCart(3);
            end
        end

        %% RUN1 XZ structural plane so perpendicular to mean V2
        A=V2.meancart(1); % Coordinates of the structural plane
        B=V2.meancart(2);
        C=V2.meancart(3);
        D = 0;
        tol=V1.length(ii)/100; % adaptative tolerance

        if Vtot.plane13(2)<45 % Adapt projection depending on the plane coordinates
            xcom=xell;
            ycom=yell;
            zcom = -(A*xcom + B*ycom + D) / C; % find Z coordinates if points XY would be on the plane
            k=1;
            pts2sel=abs(zell-zcom);
            pts2sel=pts2sel<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([zell(i,j) zcom(i,j)]))<tol % and select only points on the ellipsoid.
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        elseif Vtot.plane13(2) >= 45 && Vtot.plane13(1)>60 && Vtot.plane13(1)<120 % Adapt projection depending on the plane coordinates
            ycom=yell;
            zcom=zell;
            xcom = -(B*ycom + C*zcom + D) / A; % find X coordinates if points YZ would be on the plane
            k=1;
            pts2sel=abs(xell-xcom)<tol & abs(yell-ycom)<tol & abs(zell-zcom)<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([xell(i,j) xcom(i,j)]))<tol && abs(diff([yell(i,j) ycom(i,j)]))<tol && abs(diff([zell(i,j) zcom(i,j)]))<tol
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        elseif Vtot.plane13(2) >= 45 && Vtot.plane13(1)>240 && Vtot.plane13(1)<300 % Adapt projection depending on the plane coordinates
            ycom=yell;
            zcom=zell;
            xcom = -(B*ycom + C*zcom + D) / A; % find X coordinates if points YZ would be on the plane
            k=1;
            pts2sel=abs(xell-xcom);
            pts2sel=pts2sel<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([xell(i,j) xcom(i,j)]))<tol
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        else % Adapt projection depending on the plane coordinates
            xcom=xell;
            zcom=zell;
            ycom = -(A*xcom + C*zcom + D) / B; % find Y coordinates if points XZ would be on the plane
            k=1;
            pts2sel=abs(yell-ycom);
            pts2sel=pts2sel<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([yell(i,j) ycom(i,j)]))<tol
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        end

        dist=sqrt(X_ellipse.^2+Y_ellipse.^2+Z_ellipse.^2); % Calculates the distance to the origin

        [rowmaxt, colmaxt] = find(ismember(dist, max(dist))); % Identifies the longest axis
        rowmax=rowmaxt(1);
        colmax=colmaxt(1);

        [rowmint, colmint] = find(ismember(dist, min(dist))); % Identifies the shortes axis
        rowmin=rowmint(1);
        colmin=colmint(1);

        % And save that
        V1XZ(ii).cosine=[X_ellipse(rowmax,colmax),Y_ellipse(rowmax,colmax),Z_ellipse(rowmax,colmax)];
        V2XZ(ii).cosine=[X_ellipse(rowmin,colmin),Y_ellipse(rowmin,colmin),Z_ellipse(rowmin,colmin)];
        V1XZ(ii).length=norm(V1XZ(ii).cosine);
        V2XZ(ii).length=norm(V2XZ(ii).cosine);

        if V1XZ(ii).cosine(3)>0 % Let's normalize that and flip it to the lower hemisphere
            V1XZ(ii).cosine=-V1XZ(ii).cosine/V1XZ(ii).length;
        else
            V1XZ(ii).cosine=V1XZ(ii).cosine/V1XZ(ii).length;
        end
        if V2XZ(ii).cosine(3)>0 % Let's normalize that and flip it to the lower hemisphere
            V2XZ(ii).cosine=-V2XZ(ii).cosine/V2XZ(ii).length;
        else
            V2XZ(ii).cosine=V2XZ(ii).cosine/V2XZ(ii).length;
        end

        % Force V2prim to be orthogonal to V1prime and still be in the
        % Vtot.plane13, and replace claculated directional cosines
        V2XZ(ii).cosine=cross(V1XZ(ii).cosine,V2.meancart);
        V2XZ(ii).cosine=V2XZ(ii).cosine/sqrt(V2XZ(ii).cosine(1)^2+V2XZ(ii).cosine(2)^2+V2XZ(ii).cosine(3)^2);

        clear X_ellipse Y_ellipse Z_ellipse

        %% RUN2 YZ structural plane so perpendicular to mean V1
        A=V1.meancart(1);
        B=V1.meancart(2);
        C=V1.meancart(3);
        D = 0;
        tol=V2.length(ii)/100; % adaptative tolerance

        if Vtot.plane23(2)<45
            xcom=xell;
            ycom=yell;
            zcom = -(A*xcom + B*ycom + D) / C;
            k=1;
            pts2sel=abs(zell-zcom);
            pts2sel=pts2sel<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([zell(i,j) zcom(i,j)]))<tol
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        elseif Vtot.plane23(2) >= 45 && Vtot.plane23(1)>60 && Vtot.plane23(1)<120
            ycom=yell;
            zcom=zell;
            xcom = -(B*ycom + C*zcom + D) / A;
            k=1;
            pts2sel=abs(xell-xcom)<tol & abs(yell-ycom)<tol & abs(zell-zcom)<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([xell(i,j) xcom(i,j)]))<tol && abs(diff([yell(i,j) ycom(i,j)]))<tol && abs(diff([zell(i,j) zcom(i,j)]))<tol
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        elseif Vtot.plane23(2) >= 45 && Vtot.plane23(1)>240 && Vtot.plane23(1)<300
            ycom=yell;
            zcom=zell;
            xcom = -(B*ycom + C*zcom + D) / A;
            k=1;
            pts2sel=abs(xell-xcom);
            pts2sel=pts2sel<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([xell(i,j) xcom(i,j)]))<tol
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        else
            xcom=xell;
            zcom=zell;
            ycom = -(A*xcom + C*zcom + D) / B;
            k=1;
            pts2sel=abs(yell-ycom);
            pts2sel=pts2sel<tol;
            X_ellipse=zeros(sum(pts2sel(:)));
            Y_ellipse=zeros(sum(pts2sel(:)));
            Z_ellipse=zeros(sum(pts2sel(:)));
            for i=1:resol+1
                for j=1:resol+1
                    if abs(diff([yell(i,j) ycom(i,j)]))<tol
                        X_ellipse(k)=xcom(i,j);
                        Y_ellipse(k)=ycom(i,j);
                        Z_ellipse(k)=zcom(i,j);
                        k=k+1;
                    end
                end
            end
        end


        dist=sqrt(X_ellipse.^2+Y_ellipse.^2+Z_ellipse.^2); % Calculates the distance to the origin

        [rowmaxt, colmaxt] = find(ismember(dist, max(dist))); % Identifies the longest axis
        rowmax=rowmaxt(1);
        colmax=colmaxt(1);

        [rowmint, colmint] = find(ismember(dist, min(dist))); % Identifies the shortes axis
        rowmin=rowmint(1);
        colmin=colmint(1);

        V1YZ(ii).cosine=[X_ellipse(rowmax,colmax),Y_ellipse(rowmax,colmax),Z_ellipse(rowmax,colmax)];
        V2YZ(ii).cosine=[X_ellipse(rowmin,colmin),Y_ellipse(rowmin,colmin),Z_ellipse(rowmin,colmin)];
        V1YZ(ii).length=norm(V1YZ(ii).cosine);
        V2YZ(ii).length=norm(V2YZ(ii).cosine);


        if V1YZ(ii).cosine(3)>0 % Let's normalize that and flip it to the lower hemisphere
            V1YZ(ii).cosine=-V1YZ(ii).cosine/V1YZ(ii).length;
        else
            V1YZ(ii).cosine=V1YZ(ii).cosine/V1YZ(ii).length;
        end
        if V2YZ(ii).cosine(3)>0 % Let's normalize that and flip it to the lower hemisphere
            V2YZ(ii).cosine=-V2YZ(ii).cosine/V2YZ(ii).length;
        else
            V2YZ(ii).cosine=V2YZ(ii).cosine/V2YZ(ii).length;
        end

        % Force V2prim to be orthogonal to V1prime and still be in the
        % Vtot.plane13, and replace claculated directional cosines
        V2YZ(ii).cosine=cross(V1YZ(ii).cosine,V2.meancart);
        V2YZ(ii).cosine=V2YZ(ii).cosine/norm(V2YZ(ii).cosine);
        
        clear X_ellipse Y_ellipse Z_ellipse
    end

    %%
    %% Rf-Phi procedure
    %%

    Rf.XZ=zeros(1,size(V1XZ,2));
    Rf.YZ=zeros(1,size(V1XZ,2));
    Phi.XZ=zeros(1,size(V1XZ,2));
    Phi.YZ=zeros(1,size(V1XZ,2));

    for i=1:size(V1XZ,2)
        Rf.XZ(i)=V1XZ(i).length/V2XZ(i).length;
        Rf.YZ(i)=V1YZ(i).length/V2YZ(i).length;
    end

    %% Rotating XZ data to allow discriminating +phi and -phi - V1 vector and plane 13 being the references
    % Rotation 1: align plane towards N
    u2 = [0 0 1]; % Unitary vector of the rotation axis
    thetaR2 = Vtot.plane13(1)-90;
    thetaR2 = -pi*(thetaR2)/180; % transformation into rad
    c2 = cos(thetaR2);
    s2 = sin(thetaR2);
    R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
    for i=1:size(V1XZ,2)
        tmp = R2*V1XZ(i).cosine';
        V1XZ(i).cosine(1)=tmp(1);
        V1XZ(i).cosine(2)=tmp(2);
        V1XZ(i).cosine(3)=tmp(3);
    end
    V1.meancartp=R2*V1.meancart';
    V2.meancartp=R2*V2.meancart';
    V3.meancartp=R2*V3.meancart';

    % Rotation 2: put plane to vertical
    u2 = [0 1 0]; % Unitary vector of the rotation axis
    thetaR2 = 90-Vtot.plane13(2);
    thetaR2 = -pi*(thetaR2)/180; % transformation into rad
    c2 = cos(thetaR2);
    s2 = sin(thetaR2);
    R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
    for i=1:size(V1XZ,2)
        tmp = R2*V1XZ(i).cosine';
        V1XZ(i).cosine(1)=tmp(1);
        V1XZ(i).cosine(2)=tmp(2);
        V1XZ(i).cosine(3)=tmp(3);
    end
    V1.meancartp=R2*V1.meancartp;
    V2.meancartp=R2*V2.meancartp;
    V3.meancartp=R2*V3.meancartp;


    % Rotation 2: put reference vector vertical
    u2 = [-1 0 0]; % Unitary vector of the rotation axis
    thetaR2 = 90-atan2d(norm(cross(V1.meancartp,[0 1 0])),dot(V1.meancartp,[0 1 0])); % Rotation angle atan2(norm(cross(u,v)), dot(u,v))
    thetaR2 = -pi*(thetaR2)/180; % transformation into rad
    c2 = cos(thetaR2);
    s2 = sin(thetaR2);
    R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
    for i=1:size(V1XZ,2)
        tmp = R2*V1XZ(i).cosine';
        if tmp(3)<=0
            V1XZ(i).cosine(1)=tmp(1);
            V1XZ(i).cosine(2)=tmp(2);
            V1XZ(i).cosine(3)=tmp(3);
        else
            V1XZ(i).cosine(1)=tmp(1);
            V1XZ(i).cosine(2)=-tmp(2);
            V1XZ(i).cosine(3)=-tmp(3);
        end
    end
    V1.meancartp=R2*V1.meancartp;
    V2.meancartp=R2*V2.meancartp;
    V3.meancartp=R2*V3.meancartp;

    for i=1:size(V1XZ,2)
        Phi.XZ(i)=atan2d(norm(cross(V1.meancartp,V1XZ(i).cosine)),dot(V1.meancartp,V1XZ(i).cosine)); % Rotation angle atan2(norm(cross(u,v)), dot(u,v))
        if  V1XZ(i).cosine(2)>0
            Phi.XZ(i)=-Phi.XZ(i) ;
        end
    end


    %% Rotating YZ data to allow discriminating +phi and -phi - V2 vector and plane 23 being the references
    % Rotation 1: align plane towards N
    u2 = [0 0 1]; % Unitary vector of the rotation axis
    thetaR2 = Vtot.plane23(1)-90;
    thetaR2 = -pi*(thetaR2)/180; % transformation into rad
    c2 = cos(thetaR2);
    s2 = sin(thetaR2);
    R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
    for i=1:size(V1YZ,2)
        tmp = R2*V1YZ(i).cosine';
        V1YZ(i).cosine(1)=tmp(1);
        V1YZ(i).cosine(2)=tmp(2);
        V1YZ(i).cosine(3)=tmp(3);
    end
    V1.meancartp=R2*V1.meancart';
    V2.meancartp=R2*V2.meancart';
    V3.meancartp=R2*V3.meancart';

    % Rotation 2: put plane to vertical
    u2 = [0 1 0]; % Unitary vector of the rotation axis
    thetaR2 = 90-Vtot.plane23(2);
    thetaR2 = -pi*(thetaR2)/180; % transformation into rad
    c2 = cos(thetaR2);
    s2 = sin(thetaR2);
    R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
    for i=1:size(V1YZ,2)
        tmp = R2*V1YZ(i).cosine';
        V1YZ(i).cosine(1)=tmp(1);
        V1YZ(i).cosine(2)=tmp(2);
        V1YZ(i).cosine(3)=tmp(3);
    end
    V1.meancartp=R2*V1.meancartp;
    V2.meancartp=R2*V2.meancartp;
    V3.meancartp=R2*V3.meancartp;


    % Rotation 2: put reference vector vertical
    u2 = [-1 0 0]; % Unitary vector of the rotation axis
    thetaR2 = 90-atan2d(norm(cross(V2.meancartp,[0 1 0])),dot(V2.meancartp,[0 1 0])); % Rotation angle atan2(norm(cross(u,v)), dot(u,v))
    thetaR2 = -pi*(thetaR2)/180; % transformation into rad
    c2 = cos(thetaR2);
    s2 = sin(thetaR2);
    R2 = ([u2(1)^2*(1-c2)+c2 u2(1)*u2(2)*(1-c2)+u2(3)*s2 u2(1)*u2(3)*(1-c2)-u2(2)*s2 ; u2(1)*u2(2)*(1-c2)-u2(3)*s2 u2(2)^2*(1-c2)+c2 u2(2)*u2(3)*(1-c2)+u2(1)*s2 ; u2(1)*u2(3)*(1-c2)+u2(2)*s2 u2(2)*u2(3)*(1-c2)-u2(1)*s2 u2(3)^2*(1-c2)+c2]); % Rotation matrix
    for i=1:size(V1YZ,2)
        tmp = R2*V1YZ(i).cosine';
        if tmp(3)<=0
            V1YZ(i).cosine(1)=tmp(1);
            V1YZ(i).cosine(2)=tmp(2);
            V1YZ(i).cosine(3)=tmp(3);
        else
            V1YZ(i).cosine(1)=tmp(1);
            V1YZ(i).cosine(2)=-tmp(2);
            V1YZ(i).cosine(3)=-tmp(3);
        end
    end
    V1.meancartp=R2*V1.meancartp;
    V2.meancartp=R2*V2.meancartp;
    V3.meancartp=R2*V3.meancartp;


    for i=1:size(V1XZ,2)
        Phi.YZ(i)=atan2d(norm(cross(V2.meancartp,V1YZ(i).cosine)),dot(V2.meancartp,V1YZ(i).cosine)); % Rotation angle atan2(norm(cross(u,v)), dot(u,v))
        if  V1YZ(i).cosine(2)>0
            Phi.YZ(i)=-Phi.YZ(i) ;
        end
    end


    %%

    nsteps=50;
    % wgt=(V1.length.*V2.length.*V3.length).^(1/3); % standardization: weighted by the equal volume diameter
    % wgt=sqrt(V1.length(i)^2+V2.length(i)^2+V3.length(i)^2); % standardization for a "unit" ellipsoid
    wgt=4/3*pi*V1.length.*V2.length./V3.length; % standardization for a "unit" ellipsoid

    %%%%%%
    subplot(2,4,1)
    plot(Phi.YZ,Rf.YZ,'b.')
    hold on
    plot(mean(Phi.YZ),1./mean(1./Rf.YZ),'ro','MarkerFaceColor','r'); % Harmonic mean
    xlabel('Phi');
    ylabel('Rf');
    title('Strained YZ');
    % a=axis;
    % a(1:3)=[-90 90 1];
    % axis(a);
    set(gca,'XTick',-90:30:90);
    tt=get(gca,'YTick');
    set(gca,'YScale','log');
    set(gca,'YTick',tt);
    set(gca,'YGrid','on');
    set(gca,'XGrid','on');
    axis ([-90 90 1 max([Rf.YZ Rf.XZ])])
    xline(0, 'Color', 'k', 'LineWidth', 1);



    if weight_option==0
        % settings
        poc=length(Rf.YZ);
        % e={}; en={}; chi=[];
        nbins=round(poc/10);
        if nbins>13, nbins=13; end
        if nbins<5, nbins=5; end
        kk=Rf.YZ((Phi.YZ>-10)&(Phi.YZ<10));
        stp=(sqrt(mean(kk)+std(kk))-1)/200;
        rs=(1+(0:nsteps)*stp).^2';
        subplot(2,4,4)
        %confidence limit
        sl=2*gammaincinv(0.95/2,nbins-2/2);
        line([1;(1+nsteps*stp)^2],[sl;sl]);
        set(gca,'YScale','log');
        xlabel('Rs YZ');
        ylabel('Chi-square');
        title(['Chi-square plot df=' num2str(nbins-1)]);
        hold on

        % Load properties of ellipses
        e=cell(poc,1);
        en=cell(poc,1);
        for i=1:poc
            anr=Phi.YZ(i)*pi/180;
            r=[cos(anr) -sin(anr);...
                sin(anr)  cos(anr)];
            p=[sqrt(Rf.YZ(i)) 0;0 1/sqrt(Rf.YZ(i))];
            e{i}=(r*p)*(r*p)';
        end
        chi=zeros(1,nsteps);
        for i=0:nsteps-1
            tm=[1/(1+i*stp) 0;0 (1+i*stp)];
            for j=1:poc
                en{j}=tm*e{j}*tm';
            end
            f=eanal(en);
            n=histcounts(f,linspace(-90,90,nbins));
            n=n(1:end-1);
            chi(i+1)=sum(((n-poc/nbins).^2)/(poc/nbins));
            plot((1+i*stp)^2,chi(i+1),'k.');
            drawnow
        end
        a=axis;
        a(1:2)=[1 (1+nsteps*stp)^2];
        axis(a);

        subplot(2,4,2)
        ix=find(chi==min(chi));
        ix=ix(round(length(ix)/2));
        rs=rs(ix);
        % chitest=[chi(ix) sl];

    else
        % settings
        poc=length(Rf.YZ);
        % e={}; en={}; wrs=[];
        kk=Rf.YZ((Phi.YZ>-10)&(Phi.YZ<10));
        stp=(sqrt(mean(kk)+std(kk))-1)/200;
        rs=(1+(0:nsteps)*stp).^2;
        subplot(2,4,4)
        %set(gca,'YScale','log');
        xlabel('Rs');
        ylabel('Weighted axial ratio');
        title('Weight plot');
        hold on

        % Load properties of ellipses
        e=cell(poc,1);
        en=cell(poc,1);
        for i=1:poc
            anr=Phi.YZ(i)*pi/180;
            r=[cos(anr) -sin(anr);...
                sin(anr)  cos(anr)];
            p=[sqrt(Rf.YZ(i)) 0;0 1/sqrt(Rf.YZ(i))];
            e{i}=(r*p)*(r*p)';
        end
        wrs=zeros(1,nsteps);
        for i=0:nsteps-1
            tm=[1/(1+i*stp) 0;0 (1+i*stp)];
            for j=1:poc
                en{j}=tm*e{j}*tm';
            end
            r=eanal(en);
            wrs(i+1)=sum(r.*wgt);
            plot((1+i*stp)^2,wrs(i+1),'k.');
            drawnow
        end
        a=axis;
        a(1:2)=[1 (1+nsteps*stp)^2];
        axis(a)

        subplot(2,4,2)
        ix=find(wrs==min(wrs));
        ix=ix(round(length(ix)/2));
        rs=rs(ix);
        % wrs=wrs(ix);
        % tm=[1/(1+ix*stp) 0;0 (1+ix*stp)];
    end

    tm=[1/(1+ix*stp) 0;0 (1+ix*stp)];
    for j=1:poc
        en{j}=tm*e{j}*tm';
    end
    [f,r]=eanal(en);
    plot(f,r,'b.')
    xlabel('Phi');
    ylabel('Ri');
    title(['De-strained YZ Rs=' num2str(rs)]);
    axis ([-90 90 1 max([Rf.YZ Rf.XZ])])
    set(gca,'XTick',-90:30:90)
    tt=get(gca,'YTick');
    set(gca,'YScale','log');
    set(gca,'YTick',tt);
    set(gca,'YGrid','on');
    set(gca,'XGrid','on');
    xline(0, 'Color', 'k', 'LineWidth', 1);
    % hm=1./mean(1./Rf.YZ);   % harmonic mean
    % if nargout>2
    %     hm=1./mean(1./Rf.YZ);   % harmonic mean
    %     Isym=1-(abs(length(find(rf>hm&phi<=0))-length(find(rf>hm&phi>0)))+abs(length(find(rf<=hm&phi<=0))-length(find(rf<=hm&phi>0))))/length(rf);
    % end
    RfPhiplot(Rf.YZ,Phi.YZ,rs,3)


    %%
    %%%%%%
    subplot(2,4,5)
    plot(Phi.XZ,Rf.XZ,'b.')
    hold on
    plot(mean(Phi.XZ),1./mean(1./Rf.XZ),'ro','MarkerFaceColor','r'); % Harmonic mean
    xlabel('Phi');
    ylabel('Rf');
    title('Strained XZ');
    set(gca,'XTick',-90:30:90);
    tt=get(gca,'YTick');
    set(gca,'YScale','log');
    set(gca,'YTick',tt);
    set(gca,'YGrid','on');
    set(gca,'XGrid','on');
    axis ([-90 90 1 max([Rf.YZ Rf.XZ])])
    xline(0, 'Color', 'k', 'LineWidth', 1);


    if weight_option==0
        % settings
        poc=length(Rf.XZ);
        % e={}; en={}; chi=[];
        nbins=round(poc/10);
        if nbins>13, nbins=13; end
        if nbins<5, nbins=5; end
        kk=Rf.XZ((Phi.XZ>-10)&(Phi.XZ<10));
        stp=(sqrt(mean(kk)+std(kk))-1)/200;
        rs=(1+(0:nsteps)*stp).^2';
        subplot(2,4,8)
        %confidence limit
        sl=2*gammaincinv(0.95/2,nbins-2/2);
        line([1;(1+nsteps*stp)^2],[sl;sl]);
        set(gca,'YScale','log');
        xlabel('Rs XZ');
        ylabel('Chi-square');
        title(['Chi-square plot df=' num2str(nbins-1)]);
        hold on

        % Load properties of ellipses
        e=cell(poc,1);
        en=cell(poc,1);
        for i=1:poc
            anr=Phi.XZ(i)*pi/180;
            r=[cos(anr) -sin(anr);...
                sin(anr)  cos(anr)];
            p=[sqrt(Rf.XZ(i)) 0;0 1/sqrt(Rf.XZ(i))];
            e{i}=(r*p)*(r*p)';
        end
        chi=zeros(1,nsteps);
        for i=0:nsteps-1
            tm=[1/(1+i*stp) 0;0 (1+i*stp)];
            for j=1:poc
                en{j}=tm*e{j}*tm';
            end
            f=eanal(en);
            n=histcounts(f,linspace(-90,90,nbins));
            n=n(1:end-1);
            chi(i+1)=sum(((n-poc/nbins).^2)/(poc/nbins));
            plot((1+i*stp)^2,chi(i+1),'k.');
            drawnow
        end
        a=axis;
        a(1:2)=[1 (1+nsteps*stp)^2];
        axis(a)

        subplot(2,4,6)
        ix=find(chi==min(chi));
        ix=ix(round(length(ix)/2));
        rs=rs(ix);
        % chitest=[chi(ix) sl];

    else
        % settings
        poc=length(Rf.XZ);
        % e={}; en={}; wrs=[];
        kk=Rf.XZ((Phi.XZ>-10)&(Phi.XZ<10));
        stp=(sqrt(mean(kk)+std(kk))-1)/200;
        rs=(1+(0:nsteps)*stp).^2;
        subplot(2,4,8)
        %set(gca,'YScale','log');
        xlabel('Rs');
        ylabel('Weighted axial ratio');
        title('Weight plot');
        hold on

        % Load properties of ellipses
        e=cell(poc,1);
        en=cell(poc,1);
        for i=1:poc
            anr=Phi.XZ(i)*pi/180;
            r=[cos(anr) -sin(anr);...
                sin(anr)  cos(anr)];
            p=[sqrt(Rf.XZ(i)) 0;0 1/sqrt(Rf.XZ(i))];
            e{i}=(r*p)*(r*p)';
        end
        wrs=zeros(1,nsteps);
        for i=0:nsteps-1
            tm=[1/(1+i*stp) 0;0 (1+i*stp)];
            for j=1:poc
                en{j}=tm*e{j}*tm';
            end
            r=eanal(en);
            wrs(i+1)=sum(r.*wgt);
            plot((1+i*stp)^2,wrs(i+1),'k.');
            drawnow
        end
        a=axis;
        a(1:2)=[1 (1+nsteps*stp)^2];
        axis(a)

        subplot(2,4,6)
        ix=find(wrs==min(wrs));
        ix=ix(round(length(ix)/2));
        rs=rs(ix);
        % wrs=wrs(ix);
        % tm=[1/(1+ix*stp) 0;0 (1+ix*stp)];
    end

    [f,r]=eanal(en);
    plot(f,r,'b.')
    xlabel('Phi');
    ylabel('Ri');
    title(['De-strained XZ  Rs=' num2str(rs)]);
    axis ([-90 90 1 max([Rf.YZ Rf.XZ])])
    set(gca,'XTick',-90:30:90)
    tt=get(gca,'YTick');
    set(gca,'YScale','log');
    set(gca,'YTick',tt);
    set(gca,'YGrid','on');
    set(gca,'XGrid','on');
    xline(0, 'Color', 'k', 'LineWidth', 1);
    % hm=1./mean(1./Rf.XZ)   % harmonic mean

    RfPhiplot(Rf.XZ,Phi.XZ,rs,7)

    % Done!
    set(Text8, 'string', 'Rf-Phi successfully terminated.', 'Foregroundcolor','k') % Update text box
    set(Text27,'string','READY','BackgroundColor',[0.2 0.8 0]);

else
    set(Text8, 'string', 'It seems useless to perform Rf-Phi with one ellipsoid only... You know nothing John Snow...', 'Foregroundcolor','r') % Update text box
    return
end

end

%------------------------------------------------------------
% Helper functions
function [f,r]=eanal(e)
r=zeros(size(e,1),1);
f=zeros(size(e,1),1);
for i=1:length(e)
    [v,d]=eig(e{i});   ev=sqrt(diag(d));
    if ev(1)>ev(2)
        % r=[r;ev(1)/ev(2)];
        r(i)=ev(1)/ev(2);
        vc=v(:,1);
    else
        r(i)=ev(2)/ev(1);
        vc=v(:,2);
    end
    if vc(2)>0
        vc=-vc;
    end
    ot=acos(vc'*[-1;0])*180/pi;
    if ot>90
        ot=ot-180;
    end
    f(i)=ot;
end
end


