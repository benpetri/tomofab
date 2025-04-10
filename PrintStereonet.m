function PrintStereonet(chb7,chb9,sub1,Namein,params)
%
% function Printstereonet: Copy the Stereonet to a new figure to be saved 
% in png or eps.
% input:    - Set of UIcontrol
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

fig2 = figure('units','normalized','outerposition',[0 0 1 1]);
subnew = gobjects(3);

subnew(1) = subplot(1,1,1);
axis off

subnew = subnew';
subnew2 = gobjects(size(subnew));
subnew2(1,1) = copyobj(sub1, fig2,'legacy'); % Copy the graphics to the new figure
subnew2(1,1).Position = subnew(1,1).Position;

if get(chb7,'Value')~=1 % If density is requested
    if get(chb9,'Value') == 2 % 64 shades of grey
        customCmap=(flipud(gray));
    elseif get(chb9,'Value') == 3 % Case Jet
        customCmap=(jet);
    elseif get(chb9,'Value') == 4 % Case Parula
        customCmap=(parula);
    elseif get(chb9,'Value') == 5 % Case Bilbao % This nice Colormap is
        %     produced by Crameri F., 2018. Scientific colour-maps. Zenodo.
        %     doi:http://doi.org/10.5281/zenodo.1243862
        load('bilbao.mat','bilbao');
        customCmap=bilbao;
    end
    if get(chb9,'Value') == 1 % Case color corresponds to selected axe color
        if get(chb7,'Value')==2 % Select dataset for counting calculation
            customCmap=[linspace(1,1,64)' linspace(1,0,64)' linspace(1,0,64)'];
        elseif get(chb7,'Value')==3
            customCmap=[linspace(1,0.127,64)' linspace(1,0.746,64)' linspace(1,0.127,64)'];
        elseif get(chb7,'Value')==4
            customCmap=[linspace(1,0,64)' linspace(1,0,64)' linspace(1,1,64)'];
        end
    end
        h=colorbar;
        ylabel(h,params.densmeth)
        clim(params.denslim)
    colormap(customCmap)
%     colorbar
end

answer = questdlg('Select file format','Output format','PNG','EPS','Cancel','Cancel'); % Ask for output format
prompt='File name suffix?';
fsuf=inputdlg(prompt);

switch answer
    case 'PNG'
        tmpname=strsplit(Namein,'.');
        print(fig2,cell2mat(strcat(tmpname(1),'_',fsuf,'_snet')),'-dpng')
        close(fig2)
    case 'EPS'
        tmpname=strsplit(Namein,'.');
        print(fig2,cell2mat(strcat(tmpname(1),'_',fsuf,'_snet')),'-depsc2','-vector')
        close(fig2)
    case 'Cancel'
        close(fig2)
end


end

