%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                TOMOFAB                %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%       Graphical User Interface        %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%      Main program to be executed      %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           PRESS F5 TO START           %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           SEE ALSO README.txt         %%%%%%%%%%%%%%%%%%
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

pb1 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [0 610 120 25] ,'string' , 'Import dataset' , 'callback' , '[V1,V2,V3,Vtot,params,data,Namein,Pathin,sub1,sub2,sub3,sub4,sub5,sub6] = DataImport(sub1,sub2,sub3,sub4,sub5,sub6,Text1,Text2,Text3,Text4,Text5,Text6,Text7,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,Text27,Text28,Text29,Text30,Text31,Text32,Text33,Text34,Text36,Text37,Text39,Text41,Text43,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18,chb19);' );
pb2 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [0 585 120 25] ,'string' , 'Export dataset' , 'callback' , 'PrintDataset(Namein,V1,V2,V3,params)' );
pb3 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [0 560 120 25] ,'string' , 'Export statistics' , 'callback' , 'PrintStats(Text8,Namein,V1,V2,V3,Vtot,params)' );
pb4 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [0 535 120 25] ,'string' , 'Export stereoplot' , 'callback' , 'PrintStereonet(chb7,chb9,sub1,Namein,params)' );
pb5 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [0 510 120 25] ,'string' , 'Export fabric plots' , 'callback' , 'PrintDiagrams(chb7,chb9,sub2,sub3,sub4,sub5,sub6,Namein,params)' );

Text1=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,640,410,20] , 'string' , 'Input file:' ,'horizontalAlignment','left');
Text2=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,620,410,20] , 'string' , '... ellipsoids imported' ,'horizontalAlignment','left');
Text3=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,600,410,20] , 'string' , '... ellipsoids after null volume filtering' ,'horizontalAlignment','left');
Text4=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,580,410,20] , 'string' , '... ellipsoids after vol. & asp. ratio filtering' ,'horizontalAlignment','left');
% Text38=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,560,410,20] , 'string' , '... ellipsoids after aspect ratio filtering' ,'horizontalAlignment','left');
Text5=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,560,410,20] , 'string' , 'Ellipsoid volume range: ... - ... mm3' ,'horizontalAlignment','left');
Text39=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,540,410,20] , 'string' , 'Ellipsoid aspect ratio range: ... - ... ' ,'horizontalAlignment','left');

Text21=uicontrol ( fig1 , 'style' , ' text' , 'position', [950,520,60,20] , 'string' , 'min Vol.' ,'horizontalAlignment','left');
Text6 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [1010,520,60,20] , 'string' , '0' );
Text22=uicontrol ( fig1 , 'style' , ' text' , 'position', [1090,520,60,20] , 'string' , 'max Vol.' ,'horizontalAlignment','left');
Text7 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [1150,520,60,20] ,  'string' , '0' );

Text40 = uicontrol ( fig1 , 'style' , ' text' , 'position', [950,495,60,20] , 'string' , 'min Asp. ratio' ,'horizontalAlignment','left');
Text41 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [1010,495,60,20] , 'string' , '0' );
Text42 = uicontrol ( fig1 , 'style' , ' text' , 'position', [1090,495,60,20] , 'string' , 'max Asp. ratio' ,'horizontalAlignment','left');
Text43 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [1150,495,60,20] ,  'string' , '0' );

pb6 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [1220,518,100,25] ,'string' , 'Vol. filter' , 'callback' , '[V1, V2, V3, Vtot, data, params, sub1,sub2,sub3,sub4,sub5,sub6]=FilterVolume(data,params,Namein,Pathin,sub1,sub2,sub3,sub4,sub5,sub6,Text4,Text5,Text6,Text7,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,Text27,Text28,Text29,Text30,Text31,Text32,Text33,Text34,Text36,Text37,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18,chb19);' );
pb8 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [1220,493,100,25] ,'string' , 'Asp. ratio filter' , 'callback' , '[V1, V2, V3, Vtot, data, params, sub1,sub2,sub3,sub4,sub5,sub6]=FilterAspec(data,params,Namein,Pathin,sub1,sub2,sub3,sub4,sub5,sub6,Text4,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,Text27,Text28,Text29,Text30,Text31,Text32,Text33,Text34,Text36,Text37,Text39,Text41,Text43,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18,chb19);' );

pb9 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [1220,468,100,25] ,'string' , 'Rf-Phi' , 'callback' , 'RfPhi(V1,V2,V3,Vtot,Text8,Text27,0)' );
pb10 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [1220,443,100,25] ,'string' , 'wei. Rf-Phi' , 'callback' , 'RfPhi(V1,V2,V3,Vtot,Text8,Text27,1)' );


tbox1 = uipanel(fig1,'position',[0.5,0.005,0.495,0.04]);
Text8=uicontrol ( tbox1 , 'style' , ' text' , 'position', [10,0,650,20] , 'string' , '...' ,'horizontalAlignment','left');

Text35 = uicontrol ( fig1 , 'style' , ' text' , 'position', [10,640,70,15] , 'string' , 'STATUS : ' ,'horizontalAlignment','left');
Text27 = uicontrol ( fig1 , 'style' , ' text' , 'position', [80,640,50,15] , 'string' , 'READY' ,'horizontalAlignment','left','BackgroundColor',[0.2 0.8 0]);


%%
%% Spherical projection interface
%%

uicontrol ( fig1 , 'style' , ' text' , 'position', [10,306,70,20] , 'string' , 'Projection:' ,'horizontalAlignment','left');
chb1=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [80,310,140,20] , 'String' , 'Equal area (Schmidt)|Equal angle (Wulff)');
uicontrol ( fig1 , 'style' , ' text' , 'position', [225,306,60,20] , 'string' , 'Display:' ,'horizontalAlignment','left');
chb2=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [285,310,100,20] , 'String' , 'Max. 200 pts|All dataset');
uicontrol ( fig1 , 'style' , ' text' , 'position', [395,306,150,20] , 'string' , 'Coordinate syst.:' ,'horizontalAlignment','left');
chb3=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [515,310,100,20] , 'String' , 'Sample|Geographic');
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,276,100,20] , 'string' , 'Plot directions:' ,'horizontalAlignment','left');
chb4=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [120,280,100,20] , 'String' , 'V1','Value',1);
chb5=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [180,280,100,20] , 'String' , 'V2','Value',1);
chb6=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [240,280,100,20] , 'String' , 'V3','Value',1);
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,246,116,20] , 'string' , 'Density:' ,'horizontalAlignment','left');
chb7=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [65,250,60,20] , 'String' , 'No|V1|V2|V3');
uicontrol ( fig1 , 'style' , ' text' , 'position', [130,246,60,20] , 'string' , 'Resol.:' ,'horizontalAlignment','left');
chb8=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [180,250,60,20] , 'String' , 'Low|High');
uicontrol ( fig1 , 'style' , ' text' , 'position', [245,246,60,20] , 'string' , 'Levels:' ,'horizontalAlignment','left');
Text26 = uicontrol ( fig1 , 'style' , ' edit' , 'position', [295,250,60,20] , 'string' , '10' );
uicontrol ( fig1 , 'style' , ' text' , 'position', [365,246,120,20] , 'string' , 'Mode:' ,'horizontalAlignment','left');
chb18=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [410,250,60,20] , 'String' , '3 sig.|mud');
uicontrol ( fig1 , 'style' , ' text' , 'position', [505,246,120,20] , 'string' , 'Cmap:' ,'horizontalAlignment','left');
chb9=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [555,250,60,20] , 'String' , 'Axis|B & W|Jet|Parula|Bilbao');
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,216,130,20] , 'string' , 'Orientation stat.:' ,'horizontalAlignment','left');
chb10=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [130,220,100,20] , 'String' , 'None|Axis analysis|Orient. tensor|Fabric tensor');
uicontrol ( fig1 , 'style' , ' text' , 'position', [245,216,120,20] , 'string' , 'Tensor:' ,'horizontalAlignment','left');
chb11=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [315,220,95,20] , 'String' , 'Linear|Quadratic');
uicontrol ( fig1 , 'style' , ' text' , 'position', [445,216,120,20] , 'string' , 'Standardiz.:' ,'horizontalAlignment','left');
chb12=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [535,220,80,20] , 'String' , 'No|Yes');
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,186,120,20] , 'string' , 'Confidence ell.:' ,'horizontalAlignment','left');
chb13=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [150,190,100,20] , 'String' , 'V1');
chb14=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [210,190,100,20] , 'String' , 'V2');
chb15=uicontrol( fig1 , 'Style' , 'checkbox' , 'position' , [270,190,100,20] , 'String' , 'V3');
chb16=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [340,190,100,20] , 'String' , 'None|Fisher|Hext|Jelinek');
uicontrol ( fig1 , 'style' , ' text' , 'position', [475,185,40,20] , 'string' , 'P''-T :' ,'horizontalAlignment','left');
chb17=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [515,190,100,20] , 'String' , 'Standard plot|Polar plot|Log polar plot');
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,156,170,20] , 'string' , 'Distribution Anisotropy:' ,'horizontalAlignment','left');
chb19=uicontrol( fig1 , 'Style' , 'popup' , 'position' , [190,160,80,20] , 'String' , 'No|Yes');

pb7 = uicontrol ( fig1 , 'style' , 'push' , 'position' , [495 160 120 25] ,'string' , 'Refresh plots' , 'callback' , '[V1,V2,V3,params]=ClearVars(params); [V1,V2,V3,params] = DataFormat(data.filtered,params);[sub1,sub2,sub3,sub6,V1,V2,V3,Vtot,params]=Stereoplot(V1,V2,V3,params,Namein,Pathin,sub1,sub2,sub3,sub6,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18,chb19,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,Text27,Text28,Text29,Text30,Text31,Text32,Text33,Text34,Text36,Text37);' );

uicontrol ( fig1 , 'style' , ' text' , 'position', [10,130,200,20] , 'string' , 'Calculated mean orientations:' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,110,120,20] , 'string' , 'V1:' ,'horizontalAlignment','left','Foregroundcolor','r');
Text9 = uicontrol ( fig1 , 'style' , ' text' , 'position', [35,110,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,90,120,20] , 'string' , 'V2:' ,'horizontalAlignment','left','Foregroundcolor',[0.127 0.746 0.127]);
Text10= uicontrol ( fig1 , 'style' , ' text' , 'position', [35,90,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [10,70,120,20] , 'string' , 'V3:' ,'horizontalAlignment','left','Foregroundcolor','b');
Text11= uicontrol ( fig1 , 'style' , ' text' , 'position', [35,70,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [100,110,120,20] , 'string' , 'Lin.:' ,'horizontalAlignment','left');
Text12= uicontrol ( fig1 , 'style' , ' text' , 'position', [135,110,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [100,90,120,20] , 'string' , 'Fol.:' ,'horizontalAlignment','left');
Text13= uicontrol ( fig1 , 'style' , ' text' , 'position', [135,90,120,20] , 'string' , '.../..' ,'horizontalAlignment','left');

uicontrol ( fig1 , 'style' , ' text' , 'position', [220,130,200,20] , 'string' , 'Confidence angles:' ,'horizontalAlignment','left');
Text23 = uicontrol ( fig1 , 'style' , ' text' , 'position', [220,110,140,20] , 'string' , 'V1:  ...' ,'horizontalAlignment','left');
Text24 = uicontrol ( fig1 , 'style' , ' text' , 'position', [220,90,140,20] , 'string' , 'V2:  ...' ,'horizontalAlignment','left');
Text25 = uicontrol ( fig1 , 'style' , ' text' , 'position', [220,70,140,20] , 'string' , 'V3:  ...' ,'horizontalAlignment','left');

Text28 = uicontrol ( fig1 , 'style' , ' text' , 'position', [10,45,120,20] , 'string' , 'DA1: .../..' ,'horizontalAlignment','left');
Text29 = uicontrol ( fig1 , 'style' , ' text' , 'position', [10,25,120,20] , 'string' , 'DA2: .../..' ,'horizontalAlignment','left');
Text30 = uicontrol ( fig1 , 'style' , ' text' , 'position', [10,5,120,20] , 'string' , 'DA3: .../..' ,'horizontalAlignment','left');

Text36 = uicontrol ( fig1 , 'style' , ' text' , 'position', [120,25,140,20] , 'string' , 'DA.Lin.: .../..' ,'horizontalAlignment','left');
Text37 = uicontrol ( fig1 , 'style' , ' text' , 'position', [120,5,140,20] , 'string' , 'DA.Fol.: .../..' ,'horizontalAlignment','left');

Text31 = uicontrol ( fig1 , 'style' , ' text' , 'position', [250,25,140,20] , 'string' , 'DA.T = ...' ,'horizontalAlignment','left');
Text32 = uicontrol ( fig1 , 'style' , ' text' , 'position', [250,5,140,20] , 'string' , 'DA.P'' = ...' ,'horizontalAlignment','left');

Text33 = uicontrol ( fig1 , 'style' , ' text' , 'position', [390,25,270,20] , 'string' , 'FT.eigval = ... / ... / ...' ,'horizontalAlignment','left');
Text34 = uicontrol ( fig1 , 'style' , ' text' , 'position', [390,5,270,20] , 'string' , 'DA.eigval = ... / ... / ...' ,'horizontalAlignment','left');


%%
%% Fabric statistics graphical interface
%%

uicontrol ( fig1 , 'style' , ' text' , 'position', [350,130,200,20] , 'string' , '             P         G        R' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [360,110,120,20] , 'string' , 'V1:' ,'horizontalAlignment','left');
Text14 = uicontrol ( fig1 , 'style' , ' text' , 'position', [395,110,140,20] , 'string' , '...          ...          ...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [360,90,120,20] , 'string' , 'V2:' ,'horizontalAlignment','left');
Text15= uicontrol ( fig1 , 'style' , ' text' , 'position', [395,90,140,20] , 'string' , '...          ...          ...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [360,70,120,20] , 'string' , 'V3:' ,'horizontalAlignment','left');
Text16= uicontrol ( fig1 , 'style' , ' text' , 'position', [395,70,140,20] , 'string' , '...          ...          ...' ,'horizontalAlignment','left');

uicontrol ( fig1 , 'style' , ' text' , 'position', [540,130,50,20] , 'string' , 'Kindex = ' ,'horizontalAlignment','right');
Text17 = uicontrol ( fig1 , 'style' , ' text' , 'position', [595,130,45,20] , 'string' , '...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [540,110,50,20] , 'string' , 'LS = ' ,'horizontalAlignment','right');
Text18= uicontrol ( fig1 , 'style' , ' text' , 'position', [595,110,45,20] , 'string' , '...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [540,90,50,20] , 'string' , 'T = ' ,'horizontalAlignment','right');
Text19= uicontrol ( fig1 , 'style' , ' text' , 'position', [595,90,45,20] , 'string' , '...' ,'horizontalAlignment','left');
uicontrol ( fig1 , 'style' , ' text' , 'position', [540,70,50,20] , 'string' , ('P'' = ') ,'horizontalAlignment','right');
Text20= uicontrol ( fig1 , 'style' , ' text' , 'position', [595,70,45,20] , 'string' , '...' ,'horizontalAlignment','left');


% Resize function for better display options
set(fig1,'ResizeFcn','SizeUpdate(fig1,pb1,pb2,pb3,pb4,pb5,Text1,Text2,Text3,Text4,Text5,Text21,Text6,Text22,Text7,Text27,Text35,Text39,Text40,Text41,Text42,Text43,pb6,pb8,pb9,pb10);');