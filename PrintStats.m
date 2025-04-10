function PrintStats(Text8,Namein,V1,V2,V3,Vtot,params)
%
% function PrintStats: Print calculated statistics in comma separated
% values text file.
% input:    - V1, V2, V3: structures containing the selected set of
%           directional data.
%           - Vtot: structure containing total orientation tensor and
%           associated parameters
%           - params: structure containing calculated parameters and
%           methods of calculation
%           - File name
%           - Set of UIcontrol
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

% if strcmp(params.ormeth,'none') % Security if no statistics were calculated yet
%     set(Text8,'string','No statistics were yet calculated. Please fist compile orientation statistics', 'Foregroundcolor','r')
%     return
% end

prompt='File name suffix?';
fsuf=inputdlg(prompt);

tmpname=strsplit(Namein,'.');
fIDout = fopen(cell2mat(strcat(tmpname(1),'_',fsuf,'_stats.txt')),'w');

fprintf(fIDout,'%s %s\r\n','Input file,', Namein);
if strcmp(params.coordsys,'sample') % Print the coordinate system used for calculations
    fprintf(fIDout,'%s\r\n','Sample coordinate system');
elseif strcmp(params.coordsys,'geographic')
    fprintf(fIDout,'%s\r\n','Geographic coordinate system');
end

fprintf(fIDout,'%s %s\r\n','Blobs considered,', num2str(size(V1.cosine,1)));
fprintf(fIDout,'%s %s\r\n','Min volume,',num2str(round(params.volran(1),5)));
fprintf(fIDout,'%s %s\r\n','Max volume,',num2str(round(params.volran(2),5)));

fprintf(fIDout,'%s %s\r\n','Min aspect ratio,',num2str(round(params.aspecran(1),5)));
fprintf(fIDout,'%s %s\r\n','Max aspect ratio,',num2str(round(params.aspecran(2),5)));

fprintf(fIDout,'%s %s %s %s %s %s\r\n','V1 PGR parameters,',num2str(round(V1.PGR(1),2)),',', num2str(round(V1.PGR(2),2)),',', num2str(round(V1.PGR(3),2)));
fprintf(fIDout,'%s %s %s %s %s %s\r\n','V2 PGR parameters,',num2str(round(V2.PGR(1),2)),',', num2str(round(V2.PGR(2),2)),',', num2str(round(V2.PGR(3),2)));
fprintf(fIDout,'%s %s %s %s %s %s\r\n','V3 PGR parameters,',num2str(round(V3.PGR(1),2)),',', num2str(round(V3.PGR(2),2)),',', num2str(round(V3.PGR(3),2)));

if strcmp(params.ormeth,'axis') % Print the way statistics were calculated
    fprintf(fIDout,'%s\r\n','Axis analysis,');
elseif strcmp(params.ormeth,'ortens')
        fprintf(fIDout,'%s\r\n','Orientation tensor analysis,');
elseif strcmp(params.ormeth,'fabtens')
    if strcmp(params.tenstype,'linear')
        fprintf(fIDout,'%s\r\n','Linear fabric tensor analysis,');
    elseif strcmp(params.tenstype,'quadratic')
        fprintf(fIDout,'%s\r\n','Quadratic fabric tensor analysis,');
    end
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','FT.eigval,', num2str(round(Vtot.fteigval(1),4)) ,',', num2str(round(Vtot.fteigval(2),4)), ',',num2str(round(Vtot.fteigval(3),4)));
end

if strcmp(params.standard,'no') % Print the way statistics were calculated
    fprintf(fIDout,'%s\r\n','Ellipsoids not standardized,');
elseif strcmp(params.standard,'yes')
    fprintf(fIDout,'%s\r\n','Ellipsoids standardized,');
end

if max(size(V1.meancart)) ~= 1 % Print statistics if calculated
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','av V1 dir. cosines,', num2str(V1.meancart(1)) ,',', num2str(V1.meancart(2)), ',', num2str(V1.meancart(3)));
    fprintf(fIDout,'%s %s %s %s\r\n','av V1 DipDir/Dip,', num2str(V1.meandeg(1)) ,',', num2str(V1.meandeg(2)));
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','av V2 dir. cosines,', num2str(V2.meancart(1)) ,',', num2str(V2.meancart(2)), ',', num2str(V2.meancart(3)));
    fprintf(fIDout,'%s %s %s %s\r\n','av V2 DipDir/Dip,', num2str(V2.meandeg(1)) ,',', num2str(V2.meandeg(2)));
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','av V3 dir. cosines,', num2str(V3.meancart(1)) ,',', num2str(V3.meancart(2)), ',', num2str(V3.meancart(3)));
    fprintf(fIDout,'%s %s %s %s\r\n','av V3 DipDir/Dip,', num2str(V3.meandeg(1)) ,',', num2str(V3.meandeg(2)));
    fprintf(fIDout,'%s %s %s %s\r\n','Compiled lineation,', num2str(V1.meandeg(1))  ,',', num2str(V1.meandeg(2)));
    fprintf(fIDout,'%s %s %s %s\r\n','Compiled foliation,', num2str(round(Vtot.plane12(1),1))  ,',', num2str(round(Vtot.plane12(2),1)));
end

if strcmp(params.confmeth,'fisher')
    fprintf(fIDout,'%s\r\n','Fisher confidence ellipses,');
    fprintf(fIDout,'%s %s\r\n','E1,', num2str(V1.confang));
    fprintf(fIDout,'%s %s\r\n','E2,', num2str(V2.confang));
    fprintf(fIDout,'%s %s\r\n','E3,', num2str(V3.confang));
elseif strcmp(params.confmeth,'hext')
    fprintf(fIDout,'%s\r\n','Hext confidence ellipses,');
    fprintf(fIDout,'%s %s %s %s\r\n','E12,', num2str(V1.confang(1)), ', E13,', num2str(V1.confang(2)));
    fprintf(fIDout,'%s %s %s %s\r\n','E21,', num2str(V2.confang(1)), ', E23,', num2str(V2.confang(2)));
    fprintf(fIDout,'%s %s %s %s\r\n','E31,', num2str(V3.confang(1)), ', E32,', num2str(V3.confang(2)));
elseif strcmp(params.confmeth,'jelinek')
    fprintf(fIDout,'%s\r\n','Jelinek confidence ellipses,');
    fprintf(fIDout,'%s %s %s %s\r\n','E12,', num2str(V1.confang(1)), ', E13,', num2str(V1.confang(2)));
    fprintf(fIDout,'%s %s %s %s\r\n','E21,', num2str(V2.confang(1)), ', E23,', num2str(V2.confang(2)));
    fprintf(fIDout,'%s %s %s %s\r\n','E31,', num2str(V3.confang(1)), ', E32,', num2str(V3.confang(2)));
end



fprintf(fIDout,'%s %s\r\n','Kindex,', num2str(round(params.Kmean,3)));
fprintf(fIDout,'%s %s\r\n','LS,', num2str(round(params.LS,3)));

if params.Pjmean~=0
    fprintf(fIDout,'%s %s\r\n','T,', num2str(round(params.Tmean,3)));
    fprintf(fIDout,'%s %s\r\n','Pj,', num2str(round(params.Pjmean,3)));
end

if params.daPj~=0
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','DA.eigval,', num2str(round(Vtot.daeigval(1),4)) ,',', num2str(round(Vtot.daeigval(2),4)), ',',num2str(round(Vtot.daeigval(3),4)));
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','av DA1 dir. cosines,', num2str(Vtot.dacart(1,1)) ,',', num2str(Vtot.dacart(1,2)), ',', num2str(Vtot.dacart(1,3)));
    fprintf(fIDout,'%s %s %s %s\r\n','av DA1 DipDir/Dip,', num2str(Vtot.dadeg(1,1)) ,',', num2str(Vtot.dadeg(1,2)));
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','av DA2 dir. cosines,', num2str(Vtot.dacart(2,1)) ,',', num2str(Vtot.dacart(2,2)), ',', num2str(Vtot.dacart(2,3)));
    fprintf(fIDout,'%s %s %s %s\r\n','av DA2 DipDir/Dip,', num2str(Vtot.dadeg(2,1)) ,',', num2str(Vtot.dadeg(2,2)));
    fprintf(fIDout,'%s %s %s %s %s %s\r\n','av DA3 dir. cosines,', num2str(Vtot.dacart(3,1)) ,',', num2str(Vtot.dacart(3,2)), ',', num2str(Vtot.dacart(3,3)));
    fprintf(fIDout,'%s %s %s %s\r\n','av DA3 DipDir/Dip,', num2str(Vtot.dadeg(3,1)) ,',', num2str(Vtot.dadeg(3,2)));
    fprintf(fIDout,'%s %s %s %s\r\n','Compiled DA lineation,', num2str(Vtot.dadeg(1,1))  ,',', num2str(Vtot.dadeg(1,2)));
    fprintf(fIDout,'%s %s %s %s\r\n','Compiled DA foliation,', num2str(round(Vtot.daplane12(1),1))  ,',', num2str(round(Vtot.daplane12(2),1)));
    fprintf(fIDout,'%s %s\r\n','DA_T,', num2str(round(params.daT,3)));
    fprintf(fIDout,'%s %s\r\n','DA_ Pj,', num2str(round(params.daPj,3)));
end

if strcmp(params.densmeth,'3 sigma')
    fprintf(fIDout,'%s %s %s %s\r\n','Density (Min 3 sigma - Max 3 sigma),', num2str(round(params.denslim(1),3)),',', num2str(round(params.denslim(2),3)));
elseif strcmp(params.densmeth,'m.u.d.')
    fprintf(fIDout,'%s %s %s %s\r\n','Density (Min m.u.d. - Max m.u.d.),', num2str(round(params.denslim(1),3)),',', num2str(round(params.denslim(2),3)));
end


fclose(fIDout);

set(Text8,'string','Files successfully written', 'Foregroundcolor','k') % Refresh GUI

end


