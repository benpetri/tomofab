function PrintDataset(Namein,V1,V2,V3,params)
%
% function PrintDataset: Print filtered dataset and compiled parameters
% input:    - File name
%           - V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - params: structure containing calculated parameters and
%           methods of calculation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This file is part of µTOMOFAB. Copyright (C) 2018-2019  Benoit Petri
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

[V1.deg]=Cart2Deg(V1.cosine);
[V2.deg]=Cart2Deg(V2.cosine);
[V3.deg]=Cart2Deg(V3.cosine);

tmpname=strsplit(Namein,'.');
export = [params.head num2cell(V1.cosine) num2cell(V1.length) num2cell(V1.deg) num2cell(V2.cosine) num2cell(V2.length) num2cell(V2.deg) num2cell(V3.cosine) num2cell(V3.length) num2cell(V3.deg) num2cell(params.volall) num2cell(params.aspecall) num2cell(params.Pjall) num2cell(params.Tall)];
export = cell2table(export,'VariableNames',{'Number','Component','Unique','V1X','V1Y','V1Z','V1Length','V1DipDir','V1Dip','V2X','V2Y','V2Z','V2Length','V2DipDir','V2Dip','V3X','V3Y','V3Z','V3Length','V3DipDir','V3Dip','Volume','AspectRatio','P','T'});
writetable(export,cell2mat(strcat(tmpname(1),'.txt')))

end
