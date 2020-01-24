function [V1, V2, V3, Vtot, data, params, sub1,sub2,sub3,sub4,sub5,sub6]=VolumeFilter(data,params,Namein,Pathin,sub1,sub2,sub3,sub4,sub5,sub6,Text4,Text5,Text6,Text7,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18)
%
% function VolumeFilter: Updates selected volume range and filters
% ellipsoids depending on their volume.
% input:    - data: raw dataset
%           - params: structure containing calculated parameters and
%           methods of calculation
%           - File and path name
%           - Set of UIcontrol
% output:   - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - data: raw dataset
%           - params: structure containing calculated parameters and
%           methods of calculation
%           - Set of UIcontrol
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


if str2double(get(Text6,'string'))> str2double(get(Text7,'string')) && str2double(get(Text7,'string')) ~= 0 % Security if entered min vol > max vol.
    set(Text8, 'string', 'Error: min Vol. is bigger than max. Vol.', 'Foregroundcolor','r') % Update text box
    V1=[]; % Clear variables
    V2=[];
    V3=[];
    Vtot=[];
    return
end

if str2double(get(Text6,'string')) == 0 % If entered volume is 0: set back minimal blob volume
    params.volran(1)=min([data.raw{:,4}])-0.00001;
elseif str2double(get(Text6,'string')) > min([data.raw{:,4}]) % Otherwise, update params.volran with the entered value
    params.volran(1)=str2double(get(Text6,'string'))-0.00001;
end

if str2double(get(Text7,'string')) == 0 % If entered volume is 0: set back maximal blob volume
    params.volran(2)=max([data.raw{:,4}])+0.00001;
elseif str2double(get(Text7,'string')) < max([data.raw{:,4}]) % Otherwise, update params.volran with the entered value
    params.volran(2)=str2double(get(Text7,'string'))+0.00001;
end

data.filtered={};
j=1;
for i=1:size(data.raw,1)
    if cell2mat(data.raw(i,4))>=params.volran(1) && cell2mat(data.raw(i,4))<=params.volran(2) % Filter blobs depending on the volume and record in data.filtered
        data.filtered(j,:)=data.raw(i,:);
        j=j+1;
    end
end

[V1,V2,V3,params] = DataFormat(data.filtered,params); % Creates V1, V2, V3 and update params

set(Text4,'string',[num2str(size(data.filtered,1)) ' ellipsoids after volume filtering']) % Refresh GUI
set(Text5,'string',['Ellipsoid volume range:  ' num2str(round(params.volran(1),4)) ' - ' num2str(round(params.volran(2),4)) ' mm3']) % Refresh GUI
set(Text6,'string',num2str(round(params.volran(1),4))) % Refresh GUI
set(Text7,'string',num2str(round(params.volran(2),4))) % Refresh GUI
if size(data.filtered,1)== 0 % Display if all blobs deleted
    set(Text8,'String',['ERROR, filtering deleted ' num2str(size(data.raw,1)-size(data.filtered,1)) ' ellipsoids out of ' num2str(size(data.raw,1)-1) ' , please set lower threshold value.', 'Foregroundcolor','r']);
    return
else
    set(Text8,'String',['Volume filtering achieved, ' num2str(size(data.raw,1)-size(data.filtered,1)) ' ellipsoids deleted.'], 'Foregroundcolor','k'); % Refresh GUI
end

    
delete(sub4)
sub4=subplot(4,4,3); % Plot volume historgram
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

% Here we go
[sub1,sub2,sub3,sub6,V1,V2,V3,Vtot,params]=Stereoplot(V1,V2,V3,params,Namein,Pathin,sub1,sub2,sub3,sub6,chb1,chb2,chb3,chb4,chb5,chb6,chb7,chb8,chb9,chb10,chb11,chb12,chb13,chb14,chb15,chb16,chb17,chb18,Text8,Text9,Text10,Text11,Text12,Text13,Text14,Text15,Text16,Text17,Text18,Text19,Text20,Text23,Text24,Text25,Text26);

end

