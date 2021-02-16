function PrintDiagrams(sub2,sub3,sub4,sub5,sub6,Namein)
%
% function PrintDiagrams: Copy the fabric diagrams to a new figure to be saved in png or eps.
% input:    - Set of UIcontrol
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

fig2 = figure('units','normalized','outerposition',[0 0 1 1]);
subnew = gobjects(3);
for ii = 1:6
    subnew(ii) = subplot(2,3,ii);
    axis off
end

subnew = subnew';
subnew2 = gobjects(size(subnew));

subnew2(1,1) = copyobj(sub4, fig2); % Copy the graphics to the new figure
subnew2(1,2) = copyobj(sub5, fig2);
subnew2(2,1) = copyobj(sub2, fig2);
subnew2(2,2) = copyobj(sub3, fig2);
subnew2(2,3) = copyobj(sub6, fig2);

subnew2(1,1).Position = subnew(1,1).Position;
subnew2(1,2).Position = subnew(1,2).Position;
subnew2(2,1).Position = subnew(2,1).Position;
subnew2(2,2).Position = subnew(2,2).Position;
subnew2(2,3).Position = subnew(2,3).Position;


answer = questdlg('Select file format','Output format','PNG','EPS','Cancel','Cancel'); % Ask for output format
prompt='File name suffix?';
fsuf=inputdlg(prompt);

switch answer
    case 'PNG'
        tmpname=strsplit(Namein,'.');
        print(fig2,cell2mat(strcat(tmpname(1),'_',fsuf,'_stats')),'-dpng')
        close(fig2)
    case 'EPS'
        tmpname=strsplit(Namein,'.');
        print(fig2,cell2mat(strcat(tmpname(1),'_',fsuf,'_stats')),'-depsc')
        close(fig2)
    case 'Cancel'
        close(fig2)
end

end

