function [sub1,sub2,sub3,sub6,V1,V2,V3,Vtot,params]=Stereoplot(V1,V2,V3,params,Namein,Pathin,sub1,sub2,sub3,sub6,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25)
%
% function Stereoplot: Plots  on a Stereonet all requested information
% input:    - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - params: structure containing calculated parameters and
%           methods of calculation
%           - File and path name
%           - Set of UIcontrol
% output:   - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This file is part of �TOMOFAB. Copyright (C) 2018-2019  Benoit Petri
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

%%
%% Data rotations if geographic reference frame requested
%%

if get(chb3,'Value') == 2
    TomoName=Namein(1:7);
    orfilein='SampleOrientations.xls'; % Forced file selection containing set of sample orientations
    filein2=[Pathin orfilein];
    fIDin = fopen(filein2);
    OrAll=textscan(fIDin,'%s %f %f %s %f %f','HeaderLines',1,'Delimiter','	'); % Import all set of sample orientations
    fclose(fIDin);
    j=1;
    for i=1:size(OrAll{1},1) % Select the orientation of the right sample
        for k = 1:size(OrAll,2)
            if strcmp(TomoName, OrAll{k}(i))==1
                params.samname=char(OrAll{1}(i));
                params.samor=[OrAll{2}(i) OrAll{3}(i) OrAll{5}(i) OrAll{6}(i)];
            end
        end
        j=j+1;
    end
    [V1.cosine,~]=Rotator(params.samor, V1.cosine); % Apply rotation for full V1 dataset
    [V2.cosine,~]=Rotator(params.samor, V2.cosine); % Apply rotation for full V2 dataset
    [V3.cosine,~]=Rotator(params.samor, V3.cosine); % Apply rotation for full V3 dataset.
    params.coordsys='geographic';
end

%%
%% Plot stereonet section
%%

delete(sub1) % Delete previously plotted data
sub1=subplot(4,4,[1,2,5,6]);
hold on

N = 50;
cx = cos(0:pi/N:2*pi);
cy = sin(0:pi/N:2*pi);
xh = [-1 1];
yh = [0 0];
xv = [0 0];
yv = [-1 1];
axis([-1 1 -1 1]);
axis('square');
fill(cx,cy,'w'); % Plot a white filled circle
plot(xh,yh,xv,yv,'Color', [0.7 0.7 0.7]); % Plot axes
axis off;
hold on;

% Display projection type
if get(chb1,'Value')==1 %Equal area projection (Schmidt net) case
    text(-1,-0.9,'Equal area','Interpreter','none','FontSize',8)
    text(-1,-1,'Lower hemisphere','Interpreter','none','FontSize',8)
elseif get(chb1,'Value')==2; % Equal angle projection (W�lff net) case
    text(-1,-0.9,'Equal angle','Interpreter','none','FontSize',8)
    text(-1,-1,'Lower hemisphere','Interpreter','none','FontSize',8)
end


if get(chb7,'Value')==1; %% Plot stereonet. If interpolated density plot, avoid grid display
    if get(chb1,'Value')==1 %Equal area projection (Schmidt net) case
        for Dip = 10:10:80
            DipDir=90;
            [x,y]=GCSchmidt(DipDir,Dip);
            plot(x,y,-x,y,'Color', [0.7 0.7 0.7]); % Plot great circles
        end
        for Dip = 10:10:80
            DipDir=0;
            [x,y]=SCSchmidt(DipDir,Dip);
            plot(x,y,x,-y,'Color', [0.7 0.7 0.7]); % Plot small circles
        end
    end
    
    if get(chb1,'Value')==2; % Equal angle projection (W�lff net) case
        for Dip = 10:10:80
            DipDir=90;
            [x,y]=GCWulff(DipDir,Dip);
            plot(x,y,-x,y,'Color', [0.7 0.7 0.7]);  % Plot great circles
        end
        for Dip = 10:10:80
            DipDir=0;
            [x,y]=SCWulff(DipDir,Dip);
            plot(x,y,x,-y,'Color', [0.7 0.7 0.7]);  % Plot small circles
        end
    end
    plot(cx,cy,'-k'); % Plot black contour of the stereonet
end

axis('square');


%%
%% Density plot section
%%

if get(chb9,'Value') == 2 % 64 shades of grey
    customCmap=(flipud(gray));
elseif get(chb9,'Value') == 3 % Case Jet
    customCmap=(jet);
elseif get(chb9,'Value') == 4 % Case Parula
    customCmap=(parula);
end

if get(chb7,'Value')==2 % Select dataset for counting calculation
    PointsCart=V1.cosine;
    if get(chb9,'Value') == 1 % Case color corresponds to selected vector color
        customCmap=[linspace(1,1,64)' linspace(1,0,64)' linspace(1,0,64)'];
    end
elseif get(chb7,'Value')==3
    PointsCart=V2.cosine;
    if get(chb9,'Value') == 1 % Case color corresponds to selected vector color
        customCmap=[linspace(1,0.127,64)' linspace(1,0.746,64)' linspace(1,0.127,64)'];
    end
elseif get(chb7,'Value')==4
    PointsCart=V3.cosine;
    if get(chb9,'Value') == 1 % Case color corresponds to selected vector color
        customCmap=[linspace(1,0,64)' linspace(1,0,64)' linspace(1,1,64)'];
    end
end

if get(chb7,'Value') > 1 % Density plot is called
    if get(chb8,'Value')==1 % Case no interpolation are wanted. Counting nodes will be displayed
        [x,y,z]=DataDens(PointsCart,chb1,chb8); % Call the counting routine
        markersize=50;
        scatter(x,y,markersize,z,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',0.1); % Display the nodes
        axis([-1 1 -1 1]);
        axis('square');
        cbar=colorbar('westoutside');
        ylabel(cbar,'% per 1% area')
        colormap(customCmap)
        params.denslim=[min(min(z)) max(max(z))];
        clear PointsCart x y xi yi
    elseif get(chb8,'Value')==2 % Case cubic interpolation and contours are wanted
        [xi,yi,Counts]=DataDens(PointsCart,chb1,chb8); % Call the counting routine
        h=pcolor(xi,yi,Counts); % Display the interpolated coutings
        set(h, 'EdgeColor', 'none');
        axis([-1 1 -1 1]);
        axis('square');
        cbar=colorbar('westoutside');
        ylabel(cbar,'% per 1% area')
        colormap(customCmap)
        Counts(isnan(Counts))=0;
        maxCounts=floor(max(max(Counts)));
        if maxCounts<=10 %% Adaptative contour interval
            ci=1;
        elseif maxCounts>10 && maxCounts<=40
            ci=5;
        elseif maxCounts>40 && maxCounts<=80
            ci=10;
        elseif maxCounts>80
            ci=20;
        end
        v = 0:ci:maxCounts; % Set contouring values
        [c,ht] = contour(xi,yi,Counts,v,'k'); % Calculate the contours at the contouring values
        clabel(c,ht);
        params.denslim=[min(min(Counts)) max(max(Counts))];
        clear PointsCart x y xi yi
        plot(cx,cy,'-k'); % Plot black contour around the stereonet
    end
end

%%
%% Dataset display
%%

if get(chb2,'Value') == 1 && size(V1.cosine,1) < 200; % Adaptative display options, selects randomly maximum 200 points.
    params.dstep = 1;
elseif get(chb2,'Value') == 1 && size(V1.cosine,1) >=200
    params.dstep = ceil(size(V1.cosine,1)/200);
elseif get(chb2,'Value') == 2
    params.dstep = 1;
end


if get(chb4,'Value')==1 % V1 dataset is wanted
    j=1;
    for i=1:params.dstep:size(V1.cosine,1)
        PointsCart(j,:)=V1.cosine(i,:);
        j=j+1;
    end
    [Points]=Cart2Deg(PointsCart);
    if get(chb1,'Value')==1 % Equal area case
        [xp1,yp1]=SchmidtParams(Points);
    elseif get(chb1,'Value')==2 % Equal angle case
        [xp1,yp1]=WulffParams(Points);
    end
    plot(xp1,yp1,'or','MarkerSize',2,'MarkerFaceColor','r');
end


if get(chb5,'Value')==1 % V2 dataset is wanted
    j=1;
    for i=1:params.dstep:size(V2.cosine,1)
        PointsCart(j,:)=V2.cosine(i,:);
        j=j+1;
    end
    [Points]=Cart2Deg(PointsCart);
    if get(chb1,'Value')==1
        [xp2,yp2]=SchmidtParams(Points); % Equal area case
    elseif get(chb1,'Value')==2
        [xp2,yp2]=WulffParams(Points); % Equal angle case
    end
    plot(xp2,yp2,'o','MarkerSize',2,'MarkerFaceColor',[0.127 0.746 0.127],'MarkerEdgeColor',[0.127 0.746 0.127]);
end


if get(chb6,'Value')==1  % V3 dataset is wanted
    j=1;
    for i=1:params.dstep:size(V3.cosine,1)
        PointsCart(j,:)=V3.cosine(i,:);
        j=j+1;
    end
    [Points]=Cart2Deg(PointsCart);
    if get(chb1,'Value')==1
        [xp3,yp3]=SchmidtParams(Points); % Equal area case
    elseif get(chb1,'Value')==2
        [xp3,yp3]=WulffParams(Points); % Equal angle case
    end
    plot(xp3,yp3,'ob','MarkerSize',2,'MarkerFaceColor','b');
end

%%
%% Compile orientation statistics and shape parameters for the full dataset
%%

[V1, V2, V3, Vtot, params]=OrientationStatistics(V1,V2,V3,params,chb10,chb11,chb12);
if get(chb10,'value')~=1
    [Vtot.plane12, Vtot.plane13, Vtot.plane23]=Fabrics(V1.meancart, V2.meancart, V3.meancart); %% Calculation of foliation (V1-V2 plane) and lineation (V1 direction) orientations
end


%%
%% Confidence ellipses calculations
%%

if get(chb16,'Value')==2 && get(chb10,'value')==2 % Vector orientation statistics following Fisher (1953) methods. See function for details.
    
    params.confmeth='fisher';

    V1.confang=[]; V2.confang=[]; V3.confang=[];
    V1.confell=[]; V2.confell=[]; V3.confell=[];
    [V1.confang,V1.confell]=ConfidenceFisher(V1.cosine); % Call Fisher stats calculation for V1
    [V2.confang,V2.confell]=ConfidenceFisher(V2.cosine); % Call Fisher stats calculation for V2
    [V3.confang,V3.confell]=ConfidenceFisher(V3.cosine); % Call Fisher stats calculation for V3
    
    set(Text23,'String',['E1:  ' num2str(round(V1.confang,1))]) % Refresh GUI
    set(Text24,'String',['E2:  ' num2str(round(V2.confang,1))]) % Refresh GUI
    set(Text25,'String',['E3:  ' num2str(round(V3.confang,1))]) % Refresh GUI
    
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
    
    if get(chb13,'Value')==1
        [V1.confell]=ConfidencePlot(V1.confell,V1.meandeg,'r',chb1); % Send ellipses coordinates to plotting function
    end
    if get(chb14,'Value')==1
        [V2.confell]=ConfidencePlot(V2.confell,V2.meandeg,[0.127 0.746 0.127],chb1); % Send ellipses coordinates to plotting function
    end
    if get(chb15,'Value')==1
        [V3.confell]=ConfidencePlot(V3.confell,V3.meandeg,'b',chb1); % Send ellipses coordinates to plotting function
    end
    
    set(Text8, 'string', 'Fisher confidence ellipse calculated', 'Foregroundcolor','k') % Refresh messages text box
    
elseif get(chb16,'Value')==2 && get(chb10,'Value')~=2 % Security: Fisher method  based on vector analysis. Impossible to apply using tensor-derived mean directions
    set(Text8, 'string', 'Impossible to calculate Fisher confidence ellipses with tensor mean direction calculation', 'Foregroundcolor','r')
    set(Text23,'String','E1:  ...') % Refresh GUI
    set(Text24,'String','E2:  ...') % Refresh GUI
    set(Text25,'String','E3:  ...') % Refresh GUI
    params.confmeth='none';
    
elseif get(chb16,'Value')==3 && get(chb10,'Value')==3 % Tensor orientation statistics following Hext (1963) methods. See function for details.
    params.confmeth='hext';
    [V1,V2,V3,Vtot,params]=ConfidenceHext(V1, V2, V3, Vtot, params, Text8, Text23, Text24, Text25, chb1, chb13, chb14, chb15);
    
elseif get(chb16,'Value')==4 && get(chb10,'Value')==3 % Tensor orientation statistics following Jelinek (1976, 1978) methods. See function for details.
    params.confmeth='jelinek';
    [V1,V2,V3,Vtot,params]=ConfidenceJelinek(V1, V2, V3, Vtot, params, Text8, Text23, Text24, Text25, chb1, chb13, chb14, chb15);
    
elseif get(chb16,'Value')==3 || get(chb16,'Value')==4 && get(chb10,'Value')~=3 % Security: Hext and Jelinek methods are based on tensor analysis. Impossible to apply using vector-derived mean directions
    set(Text8, 'string', 'Impossible to calculate Hext or Jelinek confidence ellipses with vector mean direction calculation', 'Foregroundcolor','r')
    set(Text23,'String','E1:  ...') % Refresh GUI
    set(Text24,'String','E2:  ...') % Refresh GUI
    set(Text25,'String','E3:  ...') % Refresh GUI
    params.confmeth='none';
else
    set(Text23,'String','E1:  ...') % Refresh GUI
    set(Text24,'String','E2:  ...') % Refresh GUI
    set(Text25,'String','E3:  ...') % Refresh GUI
    params.confmeth='none';
end

%%
%% Mean directions
%%

if get(chb10,'Value')~=1 % Display mean directions if wanted
    
    if get(chb1,'value')==1 % Case equal area
        [x,y]=GCSchmidt(Vtot.plane12(1),Vtot.plane12(2));
    elseif get(chb1,'value')==2 % Case equal angle
        [x,y]=GCWulff(Vtot.plane12(1),Vtot.plane12(2));
    end
    plot(x,y,'--','Color', [1 0 0]);
    
    Points=V1.meandeg; % For V1 mean direction
    set(Text9,'String',[num2str(round(Points(1),0)) ' / ' num2str(round(Points(2),0))]) % Refresh GUI text box
    if get(chb1,'Value')==1 % Case equal area
        [xp,yp]=SchmidtParams(Points);
    elseif get(chb1,'Value')==2 % Case equal angle
        [xp,yp]=WulffParams(Points);
    end
    plot(xp,yp,'sk','MarkerFaceColor',[1 0 0],'MarkerSize',9);
    clearvars Points xp yp
    
    Points=V2.meandeg; % For V2 mean direction
    set(Text10,'String',[num2str(round(Points(1),0)) ' / ' num2str(round(Points(2),0))]) % Refresh GUI text box
    if get(chb1,'Value')==1 % Case equal area
        [xp,yp]=SchmidtParams(Points);
    elseif get(chb1,'Value')==2 % Case equal angle
        [xp,yp]=WulffParams(Points);
    end
    plot(xp,yp,'^k','MarkerFaceColor',[0.127 0.746 0.127],'MarkerSize',8);
    clearvars Points xp yp
    
    Points=V3.meandeg; % For V3 mean direction
    set(Text11,'String',[num2str(round(Points(1),0)) ' / ' num2str(round(Points(2),0))]) % Refresh GUI text box
    if get(chb1,'Value')==1 % Case equal area
        [xp,yp]=SchmidtParams(Points);
    elseif get(chb1,'Value')==2 % Case equal angle
        [xp,yp]=WulffParams(Points);
    end
    plot(xp,yp,'ok','MarkerFaceColor',[0 0 1],'MarkerSize',8);
    clearvars Points xp yp
    
    set(Text12,'String',[num2str(round(V1.meandeg(1),0)) ' / ' num2str(round(V1.meandeg(2),0))])
    set(Text13,'String',[num2str(round(Vtot.plane12(1),0)) ' / ' num2str(round(Vtot.plane12(2),0))])
    
else % If no mean directions were calculated, empty the GUI
    set(Text9,'String','.../...') % Refresh GUI
    set(Text10,'String','.../...') % Refresh GUI
    set(Text11,'String','.../...') % Refresh GUI
    set(Text12,'String','.../...') % Refresh GUI
    set(Text13,'String','.../...') % Refresh GUI
end

%%
%% Fabric plots
%%

[sub2,sub3,sub6]=FabricPlots(V1,V2,V3,Vtot,params,sub2,sub3,sub6,Text14,Text15,Text16,Text17,Text18,Text19,Text20,chb17); % Refresh fabric plots


end

