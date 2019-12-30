function [sub2,sub3,sub6]=FabricPlots(V1,V2,V3,Vtot,params,sub2,sub3,sub6,Text14,Text15,Text16,Text17,Text18,Text19,Text20,chb16)
%
% function FabricPlots: Plot various fabric diagrams on the GUI
% input:    - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - params: structure containing calculated parameters and
%           methods of calculation
%           - Set of UIcontrol
% output:   - Set of UIcontrol
% references:
% - Borradaile, G.J., Jackson, M., 2004. Anisotropy of magnetic susceptibility
% (AMS): magnetic petrofabrics of deformed rocks. Geol. Soc. London, Spec. Publ.
% 238, 299–360.
% - Flinn, D., 1962. On folding during three-dimensional progressive 
% deformation. Q. J. Geol. Soc. 118, 385 LP-428.
% - Jelinek, V., 1981. Characterization of the magnetic fabric of rocks. 
% Tectonophysics 79, T63–T67. doi:https://doi.org/10.1016/0040-1951(81)90110-4
% - Ramsay, J.G., 1967. Folding and fracturing of rock. McGraw-Hill, 
% New York.
% - Vollmer, F.W., 1990. An application of eigenvalue methods to structural
% domain analysis. Geol. Soc. Am. Bull. 102, 786–791.
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

delete(sub2) % Section 1: Flinn diagram (1962) modified by Ramsay (1967)
sub2=subplot(4,4,[11,15]);
hold on


for i=1:params.dstep:size(params.Kall,1) % Plot the coordinates of the points
    plot(params.Kall(i,1),params.Kall(i,2),'o','MarkerEdgeColor',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2);
end

if params.Pjmean~=0 % Plot the value of the mean orientation tensor
%     plot(log(V1.eigval(2)/V1.eigval(1)),log(V1.eigval(3)/V1.eigval(2)),'ok','MarkerFaceColor',[0 0 0])
    plot(log(Vtot.eigval(2)/Vtot.eigval(3)),log(Vtot.eigval(1)/Vtot.eigval(2)),'ok','MarkerFaceColor',[0 0 0])
else
    V1.eigval=zeros(1,3);
end

maxx=max([params.Kall(:,1); log(V1.eigval(2)/V1.eigval(1))]);
maxy=max([params.Kall(:,2); log(V1.eigval(3)/V1.eigval(2))]);


axis([0 inf 0 inf])
xlabel('log(V2/V3) - planar')
ylabel('log(V1/V2) - linear')
line([0,min([maxx maxy])],[0,min([maxx maxy])],'Color','black') % Plot the reference line
grid on


delete(sub3) % Section 2: P'-T diagrams
sub3=subplot(4,4,[12,16]);
hold on
if get(chb16,'Value')==1 %  Standard Jelinek (1981) Pj-T (P'-T) diagram
    for i=1:params.dstep:size(params.Pjall,1)
        plot(params.Pjall(i),params.Tall(i),'o','MarkerEdgeColor',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2);
    end
    if params.Pjmean~=0
        plot(params.Pjmean,params.Tmean,'ok','MarkerFaceColor',[0 0 0]) % Plot the value of the mean orientation tensor
    end
    line([1 max(xlim)],[0 0],'Color','black','LineWidth',1) % Plot the reference line
    axis([1 inf -1 1])
    text(1.5,0.9,'planar','Interpreter','none','FontSize',10)
    text(1.5,-0.9,'linear','Interpreter','none','FontSize',10)
    xlabel(('Anisotropy - P'''))
    ylabel('Shape parameter - T')
    grid on
elseif get(chb16,'Value')==2 % Polar variation of the Jelinek plot (Borradaile and Jackson, 2004) 
    hold on
   
    N = 50;
    cx = cos(-pi/4:pi/N:pi/4);
    cy = sin(-pi/4:pi/N:pi/4);
    cx=[0 cx];
    cy=[0 cy];
    xh = [0 1];
    yh = [0 0];
    axis('equal');
    fill(cx,cy,'w'); % Plot a white filled circle
    plot(xh,yh,'Color', [0.7 0.7 0.7]); % Plot axes
    axis off;
    hold on;
    
    datapointstot=[params.Pjall(:) params.Tall(:)];
    maxP=ceil(max(datapointstot(:,1)));
    
    if maxP<=2
        step=0.25;
    elseif maxP<=3
        step=0.5;
    elseif maxP<=5
        step=1;
    elseif maxP<=7
        step=2;
    elseif maxP<=15
        step=3;
    elseif maxP<=17
        step=4;
    elseif maxP<=21
        step=5;
    elseif maxP<=25
        step=6;
    else
        step=7;
    end
    
    for i=1:step:maxP
        a=linspace(-1,1,51)';
        b=ones(size(a))*i;
        Points=[b a];
        
        for j=1:size(Points,1)
            Points(j,1)=90-(Points(j,1)-1)/(maxP-1)*90;
            Points(j,2)=90-Points(j,2)*45;
        end
        
        theta = pi*(Points(:,2))/180;
        rho = pi*(Points(:,1))/180;
        xp=zeros(size(theta));
        yp=zeros(size(theta));
        for j=1:size(theta)
            trd=theta(j);
            plg=rho(j);
            if plg < 0.0
                trd = ZeroTwoPi(trd+pi);
                plg = -plg;
            end
            piS4 = pi/4.0;
            s2 = sqrt(2.0);
            plgS2 = plg/2.0;
            xpt = s2*sin(piS4 - plgS2)*sin(trd);
            ypt = s2*sin(piS4 - plgS2)*cos(trd);
            xp(j)=xpt;
            yp(j)=ypt;
        end
        
        plot(xp,yp,'Color',[0.7 0.7 0.7])
        text(xp((size(a,1)-1)/2)-0.02,yp((size(a,1)-1)/2),num2str(i),'HorizontalAlignment','Right')

    end
    
    
    ht1=text(0.60, 0.65, 'Shape  - T = 1','HorizontalAlignment','Right');
    set(ht1,'Rotation',45)
    ht2=text(0.62, 0.58, 'Planar','HorizontalAlignment','Right');
    set(ht2,'Rotation',45)
    ht3=text(0.60, -0.65, 'Shape  - T = -1','HorizontalAlignment','Right');
    set(ht3,'Rotation',-45)
    ht4=text(0.62, -0.58, 'Linear','HorizontalAlignment','Right');
    set(ht4,'Rotation',-45)
    text(1.02, 0, 'Anisotropy - P''','HorizontalAlignment','Left');

    datapoints=zeros(round(size(params.Pjall,1)/params.dstep),2);
    j=1;
    for i=1:params.dstep:size(params.Pjall,1) % Decrease the number of points to display if max 200 pts is selected
        datapoints(j,:)=[params.Pjall(i) params.Tall(i)];
        j=j+1;
    end
    
    for i=1:size(datapoints,1)
        datapoints(i,1)=90-(datapoints(i,1)-1)/(maxP-1)*90;
        datapoints(i,2)=90-datapoints(i,2)*45;
    end
    
    
    theta = pi*(datapoints(:,2))/180;
    rho = pi*(datapoints(:,1))/180;
    xp=zeros(size(theta));
    yp=zeros(size(theta));
    for i=1:size(theta)
        trd=theta(i);
        plg=rho(i);
        if plg < 0.0
            trd = ZeroTwoPi(trd+pi);
            plg = -plg;
        end
        piS4 = pi/4.0;
        s2 = sqrt(2.0);
        plgS2 = plg/2.0;
        xpt = s2*sin(piS4 - plgS2)*sin(trd);
        ypt = s2*sin(piS4 - plgS2)*cos(trd);
        xp(i)=xpt;
        yp(i)=ypt;
    end
    
    plot(xp,yp,'o','MarkerEdgeColor',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2)
    
    if params.Pjmean~=0 % Was an orientation tensor already calculated in this session?
        for i=1:size(datapoints,1)
            mean(1)=90-(params.Pjmean-1)/(maxP-1)*90;
            mean(2)=90-params.Tmean*45;
        end
        theta = pi*(mean(2))/180;
        rho = pi*(mean(1))/180;
        xp=zeros(size(theta));
        yp=zeros(size(theta));
        for i=1:size(theta)
            trd=theta(i);
            plg=rho(i);
            if plg < 0.0
                trd = ZeroTwoPi(trd+pi);
                plg = -plg;
            end
            piS4 = pi/4.0;
            s2 = sqrt(2.0);
            plgS2 = plg/2.0;
            xpt = s2*sin(piS4 - plgS2)*sin(trd);
            ypt = s2*sin(piS4 - plgS2)*cos(trd);
            xp(i)=xpt;
            yp(i)=ypt;
        end
         plot(xp,yp,'ok','MarkerFaceColor',[0 0 0]) % Plot the value of the mean orientation tensor
    end
elseif get(chb16,'Value')==3  % Polar variation of the Jelinek plot (Borradaile and Jackson, 2004) with logarithmic P' axis
    hold on
    
    N = 50;
    cx = cos(-pi/4:pi/N:pi/4);
    cy = sin(-pi/4:pi/N:pi/4);
    cx=[0 cx];
    cy=[0 cy];
    xh = [0 1];
    yh = [0 0];
    axis('equal');
    fill(cx,cy,'w'); % Plot a white filled circle
    plot(xh,yh,'Color', [0.7 0.7 0.7]); % Plot axes
    axis off;
    hold on;
    
    datapointstot=[params.Pjall(:) params.Tall(:)];
    maxP=ceil(max(datapointstot(:,1)));
    
    if maxP<=2
        step=0.25;
    elseif maxP<=3
        step=0.5;
    elseif maxP<=5
        step=1;
    elseif maxP<=7
        step=2;
    elseif maxP<=15
        step=3;
    elseif maxP<=17
        step=4;
    elseif maxP<=21
        step=5;
    elseif maxP<=25
        step=6;
    else
        step=7;
    end
    
    for i=1:step:maxP % Calculates and plot a grid and axis information
        a=linspace(-1,1,51)';
        b=ones(size(a))*i;
        Points=[b a];
        
        for j=1:size(Points,1)
            Points(j,1)=90-(log(Points(j,1)))/(log(maxP))*90;
            Points(j,2)=90-Points(j,2)*45;
        end
        
        theta = pi*(Points(:,2))/180;
        rho = pi*(Points(:,1))/180;
        xp=zeros(size(theta));
        yp=zeros(size(theta));
        for j=1:size(theta)
            trd=theta(j);
            plg=rho(j);
            if plg < 0.0
                trd = ZeroTwoPi(trd+pi);
                plg = -plg;
            end
            piS4 = pi/4.0;
            s2 = sqrt(2.0);
            plgS2 = plg/2.0;
            xpt = s2*sin(piS4 - plgS2)*sin(trd);
            ypt = s2*sin(piS4 - plgS2)*cos(trd);
            xp(j)=xpt;
            yp(j)=ypt;
        end
        
        plot(xp,yp,'Color',[0.7 0.7 0.7])
        text(xp((size(a,1)-1)/2)-0.02,yp((size(a,1)-1)/2),num2str(i),'HorizontalAlignment','Right')

    end
    
    
    ht1=text(0.60, 0.65, 'Shape  - T = 1','HorizontalAlignment','Right');
    set(ht1,'Rotation',45)
    ht2=text(0.62, 0.58, 'Planar','HorizontalAlignment','Right');
    set(ht2,'Rotation',45)
    ht3=text(0.60, -0.65, 'Shape  - T = -1','HorizontalAlignment','Right');
    set(ht3,'Rotation',-45)
    ht4=text(0.62, -0.58, 'Linear','HorizontalAlignment','Right');
    set(ht4,'Rotation',-45)
    text(1.02, 0, 'Anisotropy - P''','HorizontalAlignment','Left');

    
    datapoints=zeros(round(size(params.Pjall,1)/params.dstep),2);
    j=1;
    for i=1:params.dstep:size(params.Pjall,1) % Decrease the number of points to display if max 200 pts is selected
        datapoints(j,:)=[params.Pjall(i) params.Tall(i)];
        j=j+1;
    end
    
    datapoints(:,1)=log(datapoints(:,1))+1;
    
    for i=1:size(datapoints,1)
        datapoints(i,1)=90-(datapoints(i,1)-1)/(log(maxP))*90;
        datapoints(i,2)=90-datapoints(i,2)*45;
    end
    
    
    theta = pi*(datapoints(:,2))/180;
    rho = pi*(datapoints(:,1))/180;
    xp=zeros(size(theta));
    yp=zeros(size(theta));
    for i=1:size(theta)
        trd=theta(i);
        plg=rho(i);
        if plg < 0.0
            trd = ZeroTwoPi(trd+pi);
            plg = -plg;
        end
        piS4 = pi/4.0;
        s2 = sqrt(2.0);
        plgS2 = plg/2.0;
        xpt = s2*sin(piS4 - plgS2)*sin(trd);
        ypt = s2*sin(piS4 - plgS2)*cos(trd);
        xp(i)=xpt;
        yp(i)=ypt;
    end
    
    plot(xp,yp,'o','MarkerEdgeColor',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2)
    
    if params.Pjmean~=0 % Was an orientation tensor already calculated in this session?
        for i=1:size(datapoints,1)
            mean(1)=90-(log(params.Pjmean))/(log(maxP))*90;
            mean(2)=90-params.Tmean*45;
        end
        theta = pi*(mean(2))/180;
        rho = pi*(mean(1))/180;
        xp=zeros(size(theta));
        yp=zeros(size(theta));
        for i=1:size(theta)
            trd=theta(i);
            plg=rho(i);
            if plg < 0.0
                trd = ZeroTwoPi(trd+pi);
                plg = -plg;
            end
            piS4 = pi/4.0;
            s2 = sqrt(2.0);
            plgS2 = plg/2.0;
            xpt = s2*sin(piS4 - plgS2)*sin(trd);
            ypt = s2*sin(piS4 - plgS2)*cos(trd);
            xp(i)=xpt;
            yp(i)=ypt;
        end
         plot(xp,yp,'ok','MarkerFaceColor',[0 0 0]) % Plot the value of the mean orientation tensor
    end
end


delete(sub6) % Section 3: Vollmer (1990) PGR triangular diagram
sub6=subplot(4,4,8);
hold on

xma=0.5*(2*V1.PGR(2)+V1.PGR(3));
yma=sqrt(3)/2-sqrt(3)/2*V1.PGR(3);
xin=0.5*(2*V2.PGR(2)+V2.PGR(3));
yin=sqrt(3)/2-sqrt(3)/2*V2.PGR(3);
xmi=0.5*(2*V3.PGR(2)+V3.PGR(3));
ymi=sqrt(3)/2-sqrt(3)/2*V3.PGR(3);

cx = [0 1 0.5 0]; % Triangle diagram axes
cy = [sqrt(3)/2 sqrt(3)/2 0 sqrt(3)/2]; % Triangle diagram axes
axis([0 1 0 1]);
axis('square');
fill(cx,cy,'w'); % Triangle diagram white background
for i=1:9
    plot([0.5-i/20 0.5+i/20],[sqrt(3)/2*i/10 sqrt(3)/2*i/10],'Color', [0.7 0.7 0.7]); % Triangle diagram grid
    plot([i/10 0.5+i/20],[sqrt(3)/2 sqrt(3)/2*i/10],'Color', [0.7 0.7 0.7]); % Triangle diagram grid
    plot([i/20 i/10],[sqrt(3)/2-sqrt(3)/2*i/10 sqrt(3)/2],'Color', [0.7 0.7 0.7]); % Triangle diagram grid
end
text(-0.2,0.9,'P','Interpreter','none','FontSize',10)
text(1.05,0.9,'G','Interpreter','none','FontSize',10)
text(0.45,-0.1,'R','Interpreter','none','FontSize',10)
plot(cx,cy,'-k'); % Triangle diagram black frame
axis off;
hold on;

plot(xma,yma,'or','MarkerSize',6,'MarkerFaceColor','r')
plot(xin,yin,'o','MarkerSize',6,'MarkerFaceColor',[0.147 0.746 0.147],'MarkerEdgeColor',[0.147 0.746 0.147])
plot(xmi,ymi,'ob','MarkerSize',6,'MarkerFaceColor','b')

set(Text14,'String',[num2str(round(V1.PGR(1),2)) '     ' num2str(round(V1.PGR(2),2)) '     ' num2str(round(V1.PGR(3),2))]) % Refresh GUI
set(Text15,'String',[num2str(round(V2.PGR(1),2)) '     ' num2str(round(V2.PGR(2),2)) '     ' num2str(round(V2.PGR(3),2))]) % Refresh GUI
set(Text16,'String',[num2str(round(V3.PGR(1),2)) '     ' num2str(round(V3.PGR(2),2)) '     ' num2str(round(V3.PGR(3),2))]) % Refresh GUI
if params.Pjmean~=0 % If Pj was calculated
    set(Text17,'String',num2str(round(params.Kmean,2))) % Refresh GUI
    set(Text18,'String',num2str(round(params.LS,2))) % Refresh GUI
    set(Text19,'String',num2str(round(params.Tmean,2))) % Refresh GUI
    set(Text20,'String',num2str(round(params.Pjmean,2))) % Refresh GUI
else % If Pj was not calculated yet (no tensor analysis was performed)
    set(Text17,'String',num2str(round(params.Kmean,2))) % Refresh GUI
    set(Text18,'String',num2str(round(params.LS,2))) % Refresh GUI
    set(Text19,'String','...') % Refresh GUI
    set(Text20,'String','...') % Refresh GUI
end


end

