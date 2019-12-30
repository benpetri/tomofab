%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                TOMOFAB                %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%       Graphical User Interface        %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%      Main program to be executed      %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           PRESS F5 TO START           %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           SEE ALSO README.txt         %%%%%%%%%%%%%%%%%%
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

clearvars
close all

% fig1 = figure('units','normalized','outerposition',[0 0 1 1]);
% fig1 = figure('units','normalized','outerposition',[-0.705 0.29 0.70 0.70]);
fig1 = figure('units','pixel','position',[20 35 1320 665]); %Initialize figure and set its size and associated sub-windows
% fig1 = figure('units','pixel','position',[-1350 330 1320 665]); %Initialize figure and set its size and associated sub-windows
sub1=subplot(4,4,[1,2,5,6]);
axis off;
sub2=subplot(4,4,[11,15]);
axis off;
sub3=subplot(4,4,[12,16]);
axis off;
sub4=subplot(4,4,3);
axis off;
sub5=subplot(4,4,7);
axis off;
sub6=subplot(4,4,8);
axis off;


%%
%% Data importation and volume filtering interface
%%

pb1 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [720 640 120 25] ,'string' , 'Import dataset' , 'callback' , '[V1,V2,V3,Vtot,params,data,Namein,Pathin,sub1,sub2,sub3,sub4,sub5,sub6] = DataImport(sub1,sub2,sub3,sub4,sub5,sub6,Text1,Text2,Text3,Text4,Text5,Text6,Text7,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17);' );
pb2 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [840 640 120 25] ,'string' , 'Export dataset' , 'callback' , 'PrintDataset(Namein,V1,V2,V3,params)' );
pb3 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [960 640 120 25] ,'string' , 'Export statistics' , 'callback' , 'PrintStats(Text8,Namein,V1,V2,V3,Vtot,params)' );
pb4 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [1080 640 120 25] ,'string' , 'Export stereoplot' , 'callback' , 'PrintStereonet(chb7,chb9,sub1,Namein)' );
pb5 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [1200 640 120 25] ,'string' , 'Export fabric plots' , 'callback' , 'PrintDiagrams(sub2,sub3,sub4,sub5,sub6,Namein)' );

Text1=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,610,410,20] , 'string' , 'Input file:' ,'horizontalAlignment','left');
Text2=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,590,410,20] , 'string' , '... ellipsoids imported' ,'horizontalAlignment','left');
Text3=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,570,410,20] , 'string' , '... ellipsoids after null volume filtering' ,'horizontalAlignment','left');
Text4=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,550,410,20] , 'string' , '... ellipsoids after volume filtering' ,'horizontalAlignment','left');
Text5=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,530,410,20] , 'string' , 'Ellipsoid volume range: ... - ... mm3' ,'horizontalAlignment','left');
Text21=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,510,60,20] , 'string' , 'min Vol.' ,'horizontalAlignment','left');
Text6 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [1010,510,60,20] , 'string' , '0' );
Text22=uicontrol ( fig1 , 'style' , ' text' , 'position', [1090,510,60,20] , 'string' , 'max Vol.' ,'horizontalAlignment','left');
Text7 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [1150,510,60,20] ,  'string' , '0' );
pb6 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [950,480,200,25] ,'string' , 'Refresh volume filtering' , 'callback' , '[V1, V2, V3, Vtot, data, params, sub1,sub2,sub3,sub4,sub5,sub6]=VolumeFilter(data,params,Namein,Pathin,sub1,sub2,sub3,sub4,sub5,sub6,Text4,Text5,Text6,Text7,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17);' );

tbox1 = uipanel(fig1,'position',[0.5,0.005,0.495,0.04]);
Text8=uicontrol ( tbox1 , 'style' , ' text' , 'position', [10,0,500,20] , 'string' , '...' ,'horizontalAlignment','left');


%%
%% Spherical projection interface
%%

uicontrol ( fig1 , 'style' , ' text' , 'position', [30,296,70,20] , 'string' , 'Projection:' ,'horizontalAlignment','left');
chb1=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [100,300,140,20] , 'String' , 'Equal area (Schmidt)|Equal angle (Wulff)');
uicontrol ( fig1 , 'style' , ' text' , 'position', [300,296,60,20] , 'string' , 'Display:' ,'horizontalAlignment','left');
chb2=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [360,300,100,20] , 'String' , 'Max. 200 pts|All dataset');
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,266,150,20] , 'string' , 'Coordinate system:' ,'horizontalAlignment','left');
chb3=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [160,270,100,20] , 'String' , 'Sample|Geographic');
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,236,100,20] , 'string' , 'Plot directions:' ,'horizontalAlignment','left');
chb4=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [140,240,100,20] , 'String' , 'V1','Value',1);
chb5=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [200,240,100,20] , 'String' , 'V2','Value',1);
chb6=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [260,240,100,20] , 'String' , 'V3','Value',1);
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,206,116,20] , 'string' , 'Density:' ,'horizontalAlignment','left');
chb7=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [85,210,90,20] , 'String' , 'None|V1 directions|V2 directions|V3 directions');
uicontrol ( fig1 , 'style' , ' text' , 'position', [185,206,60,20] , 'string' , 'Resol.:' ,'horizontalAlignment','left');
chb8=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [235,210,100,20] , 'String' , 'Low|High');
uicontrol ( fig1 , 'style' , ' text' , 'position', [350,206,60,20] , 'string' , 'Levels:' ,'horizontalAlignment','left');
Text26 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [400,210,60,20] , 'string' , '10' );
uicontrol ( fig1 , 'style' , ' text' , 'position', [505,206,120,20] , 'string' , 'Cmap:' ,'horizontalAlignment','left');
chb9=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [555,210,60,20] , 'String' , 'Axis|B & W|Jet|Parula|Bilbao');
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,176,130,20] , 'string' , 'Orientation statistics:' ,'horizontalAlignment','left');
chb10=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [150,180,100,20] , 'String' , 'None|Axis analysis|Tensor analysis');
uicontrol ( fig1 , 'style' , ' text' , 'position', [265,176,120,20] , 'string' , 'Tensor type:' ,'horizontalAlignment','left');
chb11=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [335,180,95,20] , 'String' , 'Linear|Quadratic');
uicontrol ( fig1 , 'style' , ' text' , 'position', [445,176,120,20] , 'string' , 'Standardization:' ,'horizontalAlignment','left');
chb12=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [535,180,80,20] , 'String' , 'No|Yes');
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,146,120,20] , 'string' , 'Confidence ellipses:' ,'horizontalAlignment','left');
chb13=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [170,150,100,20] , 'String' , 'V1');
chb14=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [230,150,100,20] , 'String' , 'V2');
chb15=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [290,150,100,20] , 'String' , 'V3');
chb16=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [360,150,100,20] , 'String' , 'None|Fisher|Hext|Jelinek');

pb7 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [165 120 120 25] ,'string' , 'Refresh plots' , 'callback' , '[V1,V2,V3,params]=ClearVars(params); [V1,V2,V3,params] = DataFormat(data.filtered,params);[sub1,sub2,sub3,sub6,V1,V2,V3,Vtot,params]=Stereoplot(V1,V2,V3,params,Namein,Pathin,sub1,sub2,sub3,sub6,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26);' );

uicontrol ( fig1 , 'style' , ' text' , 'position', [30,90,200,20] , 'string' , 'Calculated mean orientations:' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,70,120,20] , 'string' , 'V1:' ,'horizontalAlignment','left','Foregroundcolor','r');
Text9 = uicontrol ( fig1 , 'style' , ' text' , 'position', [55,70,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,50,120,20] , 'string' , 'V2:' ,'horizontalAlignment','left','Foregroundcolor',[0.127 0.746 0.127]);
Text10= uicontrol ( fig1 , 'style' , ' text' , 'position', [55,50,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [30,30,120,20] , 'string' , 'V3:' ,'horizontalAlignment','left','Foregroundcolor','b');
Text11= uicontrol ( fig1 , 'style' , ' text' , 'position', [55,30,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [120,70,120,20] , 'string' , 'Lineation:' ,'horizontalAlignment','left');
Text12= uicontrol ( fig1 , 'style' , ' text' , 'position', [175,70,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [120,50,120,20] , 'string' , 'Foliation:' ,'horizontalAlignment','left');
Text13= uicontrol ( fig1 , 'style' , ' text' , 'position', [175,50,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');

uicontrol ( fig1 , 'style' , ' text' , 'position', [240,90,200,20] , 'string' , 'Confidence angles:' ,'horizontalAlignment','left');
Text23 = uicontrol ( fig1 , 'style' , ' text' , 'position', [240,70,120,20] , 'string' , 'V1:  ...' ,'horizontalAlignment','left');
Text24 = uicontrol ( fig1 , 'style' , ' text' , 'position', [240,50,200,20] , 'string' , 'V2:  ...' ,'horizontalAlignment','left');
Text25 = uicontrol ( fig1 , 'style' , ' text' , 'position', [240,30,120,20] , 'string' , 'V3:  ...' ,'horizontalAlignment','left');



%%
%% Fabric statistics graphical interface
%%

uicontrol ( fig1 , 'style' , ' text' , 'position', [370,90,200,20] , 'string' , '             P         G        R' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [380,70,120,20] , 'string' , 'V1:' ,'horizontalAlignment','left');
Text14 = uicontrol ( fig1 , 'style' , ' text' , 'position', [415,70,120,20] , 'string' , '...          ...          ...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [380,50,120,20] , 'string' , 'V2:' ,'horizontalAlignment','left');
Text15= uicontrol ( fig1 , 'style' , ' text' , 'position', [415,50,120,20] , 'string' , '...          ...          ...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [380,30,120,20] , 'string' , 'V3:' ,'horizontalAlignment','left');
Text16= uicontrol ( fig1 , 'style' , ' text' , 'position', [415,30,120,20] , 'string' , '...          ...          ...' ,'horizontalAlignment','left');

uicontrol ( fig1 , 'style' , ' text' , 'position', [560,90,50,20] , 'string' , 'Kindex = ' ,'horizontalAlignment','right');
Text17 = uicontrol ( fig1 , 'style' , ' text' , 'position', [615,90,45,20] , 'string' , '...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [560,70,50,20] , 'string' , 'LS = ' ,'horizontalAlignment','right');
Text18= uicontrol ( fig1 , 'style' , ' text' , 'position', [615,70,45,20] , 'string' , '...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [560,50,50,20] , 'string' , 'T = ' ,'horizontalAlignment','right');
Text19= uicontrol ( fig1 , 'style' , ' text' , 'position', [615,50,45,20] , 'string' , '...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [560,30,50,20] , 'string' , ('P'' = ') ,'horizontalAlignment','right');
Text20= uicontrol ( fig1 , 'style' , ' text' , 'position', [615,30,45,20] , 'string' , '...' ,'horizontalAlignment','left');

uicontrol ( fig1 , 'style' , ' text' , 'position', [475,145,40,20] , 'string' , 'P''-T :' ,'horizontalAlignment','left');
chb17=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [515,150,100,20] , 'String' , 'Standard plot|Polar plot|Log polar plot');

%% Resize function for better display options
set(fig1,'ResizeFcn','SizeUpdate(fig1,pb1,pb2,pb3,pb4,pb5,Text1,Text2,Text3,Text4,Text5,Text21,Text6,Text22,Text7,pb6);');