function [V1, V2, V3, params]=ClearVars(params)
%
% function ClearVars: clear variables before reimporting the dataset.
% input:	- params: structure containing calculated parameters and
%           methods of calculation
% output:	- V1, V2, V3: structures containing the selected set of 
%           directional data.
%           - params: structure containing calculated parameters and
%           methods of calculation
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

V1=[];
V2=[];
V3=[];
params.volall=[];
params.aspecall=[];
params.dstep=[];
params.LS=[];
params.Tall=[];
params.Pjall=[];
params.Tmean=[];
params.Pjmean=[];

end

