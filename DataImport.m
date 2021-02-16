function [V1,V2,V3,Vtot,params,data,Namein,Pathin,sub1,sub2,sub3,sub4,sub5,sub6] = DataImport(sub1,sub2,sub3,sub4,sub5,sub6,Text1,Text2,Text3,Text4,Text5,Text6,Text7,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,Text27,Text28,Text29,Text30,Text31,Text32,Text33,Text34,Text36,Text37,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18,chb19)
%
% function DataImport: Import dataset from a csv file haveing .xls
% extension
% input:	- Set of UIcontrol
% output:   - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
%           - data: raw and filtered dataset
%           - File and path name
%           - Set of UIcontrol
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

clearvars -except sub1 sub2 sub3 sub4 sub5 sub6 Text1 Text2 Text3 Text4 Text5 Text6 Text7 Text8 Text9 Text10 Text11 Text12 Text13 Text14 Text15 Text16 Text17 Text18 Text19 Text20 Text21 Text22 Text23 Text24 Text25 Text26 Text27 Text28 Text29 Text30 Text31 Text32 Text33 Text34 Text36 Text37 chb1 chb2 chb3 chb4 chb5 chb6 chb7 chb8 chb9 chb10 chb11 chb12 chb13 chb14 chb15 chb16 chb17 chb18 chb19


%% Manual file selection
% if ManInp == 1
    [Namein,Pathin]=uigetfile('*.xls','Input file?'); % Manual file selection
    filein=[Pathin Namein];
% end

%% Forced file selection
% if ForInp == 1
%     Pathin=['Z:\Geology\Matlab_Workspace\Tomography\Development\FABRIX\']; % Forced file selection
%     Namein=['TT_1185_Pyroxene-Amphibole_1Median_AutoSeparation-dat.xls'];  % Forced file selection
%     filein=[Pathin Namein]; % Forced file selection
% end

%%
%% Loading blobs
%%

fIDin = fopen(filein);
raw=textscan(fIDin,'%f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','HeaderLines',1,'Delimiter','	');
fclose(fIDin);

%% Filtering deleting null blobs
j=1;

for i=1:size(raw{1},1)
    if raw{4}(i)~=0
        if raw{5}(i)~=0 && raw{6}(i)~=0 && raw{7}(i)~=0
            for k = 1:size(raw,2)
                data.raw{j,k}=raw{k}(i);
            end
            j=j+1;
        end
    end
end

if size(data.raw,1)== 0 % Security if all blobs are null or an error occured during data importation
    set(Text8,'String',['ERROR, null filtering deleted ' num2str(size(raw{1},1)-size(data.raw{1},1)) ' blobs out of ' num2str(size(raw{1},1)) ', please check raw data file.']);
    return
else
    set(Text8,'string',[num2str(size(raw{1},1)) ' blobs successfully loaded; Null filtering achieved, ' num2str(size(raw{1},1)-size(data.raw,1)) ' blobs deleted.']);
end

params.volran=[min([data.raw{:,4}]) max([data.raw{:,4}])]; % Update the volume range with the minimal and maximal blob volume in entry data set

set(Text1,'string',['Input: ' Namein]) % Refresh GUI
set(Text2,'string',[num2str(size(raw{1},1)) ' ellipsoids imported']) % Refresh GUI
set(Text3,'string',[num2str(size(data.raw,1)) ' ellipsoids after null volume filtering']) % Refresh GUI
set(Text4,'string',[num2str(size(data.raw,1)) ' ellipsoids after volume filtering']) % Refresh GUI
set(Text5,'string',['Ellipsoid volume range:  ' num2str(round(params.volran(1),4)) ' - ' num2str(round(params.volran(2),4)) ' mm3']) % Refresh GUI
set(Text6,'string',num2str(round(params.volran(1),4))) % Refresh GUI
set(Text7,'string',num2str(round(params.volran(2),4))) % Refresh GUI

data.filtered=data.raw; % Copy raw data to filtered data as no volume filter should be applied during importation.

[V1,V2,V3,params] = DataFormat(data.filtered,params); % Creates the dataset that will be processed and updates the associated parameters

delete(sub4)
sub4=subplot(4,4,3); % Plot blob volume histogram
histogram(params.volall,30)
xlabel('Ellipsoid volume [mm^3]')
ylabel('Number of ellipsoids')
axis([0 max(params.volall)+max(params.volall)/4 0 inf])
set(gca,'YScale','log')
grid on

delete(sub5)
sub5=subplot(4,4,7); % Plot aspect ratio histogram
histogram(params.aspecall,30)
xlabel('Aspect ratio')
ylabel('Number of ellipsoids')
axis([1 max(params.aspecall)+max(params.aspecall)/4 0 inf])
grid on

params.coordsys='sample';

% Run the calculation and plotting options
[sub1,sub2,sub3,sub6,V1,V2,V3,Vtot,params]=Stereoplot(V1,V2,V3,params,Namein,Pathin,sub1,sub2,sub3,sub6,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18,chb19,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,Text27,Text28,Text29,Text30,Text31,Text32,Text33,Text34,Text36,Text37);

end

