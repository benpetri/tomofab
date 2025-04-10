function [V1,V2,V3,params] = DataFormat(FilteredData,params)
%
% function DataFormat: Transform raw dataset to formatted structures
% input:    - FilteredData: raw dataset (cell)
%           - params: structure containing calculated parameters and
%           methods of calculation
% output:   - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - params: structure containing calculated parameters and
%           methods of calculation
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

V1.cosine = zeros(size(FilteredData,1),3);
V1.length = zeros(size(FilteredData,1),1);
V2.cosine = zeros(size(FilteredData,1),3);
V2.length = zeros(size(FilteredData,1),1);
V3.cosine = zeros(size(FilteredData,1),3);
V3.length = zeros(size(FilteredData,1),1);
params.posall = zeros(size(FilteredData,1),3);
params.volall = zeros(size(FilteredData,1),1);
params.aspecall = zeros(size(FilteredData,1),1);
params.head = cell(size(FilteredData,1),3);

% display(FilteredData)

V1.cosine=[cell2mat(FilteredData(:,11)) cell2mat(FilteredData(:,12)) cell2mat(FilteredData(:,13))]; % Extract directional cosines
V1.length=cell2mat(FilteredData(:,8))*2; % Extract  radius and transform to length
V2.cosine=[cell2mat(FilteredData(:,14)) cell2mat(FilteredData(:,15)) cell2mat(FilteredData(:,16)) ];
V2.length=cell2mat(FilteredData(:,9))*2;
V3.cosine=[cell2mat(FilteredData(:,17)) cell2mat(FilteredData(:,18)) cell2mat(FilteredData(:,19)) ];
V3.length=cell2mat(FilteredData(:,10))*2;
params.posall=[cell2mat(FilteredData(:,5)) cell2mat(FilteredData(:,6)) cell2mat(FilteredData(:,7))];  % Extract ellipsoid position
params.volall=cell2mat(FilteredData(:,4)); % Extract ellipsoid volume
% params.aspecall=cell2mat(FilteredData(:,5)); % Extract ellipsoid aspect ratio
params.aspecall=cell2mat(FilteredData(:,8))./cell2mat(FilteredData(:,10)); % Extract ellipsoid aspect ratio
params.head=[FilteredData(:,1) FilteredData(:,2) FilteredData(:,3)];  % Extract headers of the table containing e.g. ellipsoid identifier

for i=1:size(FilteredData,1) % replace all directional cosines to the lower hemisphere
    if V1.cosine(i,3)>0
        V1.cosine(i,1)=-V1.cosine(i,1);
        V1.cosine(i,2)=-V1.cosine(i,2);
        V1.cosine(i,3)=-V1.cosine(i,3);
    end
    if V2.cosine(i,3)>0
        V2.cosine(i,1)=-V2.cosine(i,1);
        V2.cosine(i,2)=-V2.cosine(i,2);
        V2.cosine(i,3)=-V2.cosine(i,3);
    end
    if V3.cosine(i,3)>0
        V3.cosine(i,1)=-V3.cosine(i,1);
        V3.cosine(i,2)=-V3.cosine(i,2);
        V3.cosine(i,3)=-V3.cosine(i,3);
    end
end

end

