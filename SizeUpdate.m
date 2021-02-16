function SizeUpdate(fig1,pb1,pb2,pb3,pb4,pb5,Text1,Text2,Text3,Text4,Text5,Text21,Text6,Text22,Text7,Text27,Text35,pb6)
%
% function SizeUpdate: Update the position of UIcontrol objects when the GUI figure is resized by the user
% Allow to adapt to different screens
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

% Initial figure position: [20 35 1320 665]
% monres = get(0,'MonitorPosition'); % Get the resolution of the screen
figpos = get(fig1,'Position'); % Get the position of the main figure

set(pb1, 'position' , [figpos(3)-600 figpos(4)-25 120 25]);
set(pb2, 'position' , [figpos(3)-480 figpos(4)-25 120 25]);
set(pb3, 'position' , [figpos(3)-360 figpos(4)-25 120 25]);
set(pb4, 'position' , [figpos(3)-240 figpos(4)-25 120 25] );
set(pb5, 'position' , [figpos(3)-120 figpos(4)-25 120 25]);

set(Text1, 'position', [figpos(3)-370,figpos(4)-55,410,20]);
set(Text2, 'position', [figpos(3)-370,figpos(4)-75,410,20]);
set(Text3, 'position', [figpos(3)-370,figpos(4)-95,410,20]);
set(Text4, 'position', [figpos(3)-370,figpos(4)-115,410,20]);
set(Text5, 'position', [figpos(3)-370,figpos(4)-135,410,20]);
set(Text21, 'position', [figpos(3)-370,figpos(4)-155,60,20]);
set(Text6, 'position', [figpos(3)-310,figpos(4)-155,60,20]);
set(Text22, 'position', [figpos(3)-230,figpos(4)-155,60,20]);
set(Text7, 'position', [figpos(3)-170,figpos(4)-155,60,20]);
set(pb6, 'position' , [figpos(3)-370,figpos(4)-185,200,25]);

set(Text27, 'position', [100,figpos(4)-27,50,15]);
set(Text35, 'position', [30,figpos(4)-27,70,15]);

end

