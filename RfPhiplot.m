function RfPhiplot(Rf,Phi,Rs,plotnum)
%
% function RfPhiPlot: plots Rf/Phi routine diagrams.
%
% input:	- Rf: structures containing the selected set of 
%           directional data.
%           - Phi: structure containing total orientation tensor and
%           associated parameters.
%           - Rs: Rs estimated by the RfPhi function
%           - plotnum: subplot identifier.
% This function integrates parts of PolyLX routines (Lexa, 2003).
% reference:
% - Lexa, O., 2003. Numerical Approaches in Structural and Micro structural 
% Analyses. Unpublished PhD thesis, Charles University, Prague.
%
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


figure(2)
subplot(2,4,plotnum)

ang=Phi';
ar=Rf';

opts.rs=Rs;
opts.mdang=[];
opts.rfmax=exp(mean(log(ar))+3*std(log(ar)));
opts.ncont=10;
opts.pointsize=6;
opts.pointcolor='b.';
opts.linewidth=2;
opts.linecolor='r';
opts.colormap=bone;
opts.gauss=1;


%Calculate vector mean
xr=sum(sin(deg2rad(2*ang)));
yr=sum(cos(deg2rad(2*ang)));
if isempty(opts.mdang)
    mdang=rad2deg(atan2(xr,yr))/2;    % mean direction
    if mdang<0
        mdang=mdang+180;
    end
else
    mdang=opts.mdang;
end
sang=rad2deg(sqrt(log(1/(sqrt(xr^2+yr^2)/length(ang))^2)))/2; % circular standard deviation
rfmean=length(ar)/sum(1./ar);

% ang=ang-mdang
ixxx=find(ang>90);
ang(ixxx)=ang(ixxx)-180;
ixxx=find(ang<-90);
ang(ixxx)=ang(ixxx)+180;
na=length(find((ang<0)&ar>rfmean));
nb=length(find((ang>0)&ar>rfmean));
nc=length(find((ang<0)&ar<rfmean));
nd=length(find((ang>0)&ar<rfmean));
isym=1-(abs(na-nb)+abs(nc-nd))/length(ang);

ang=[ang-180;ang;ang+180];
ar=[ar;ar;ar];

cla

% Gauss density
if opts.gauss~=0
    n=length(ang);
    h = 1.06 * std(ang) * n^(-1/5);
    mn1 = -180;
    mx1 = 360;
    mn = mn1 - (mx1-mn1)/3;
    mx = mx1 + (mx1-mn1)/3;
    gridsize = 256;
    xx = linspace(mn,mx,gridsize)';
    d = xx(2) - xx(1);
    xh = zeros(size(xx));
    xa = (ang-mn)/(mx-mn)*gridsize;
    for i=1:n
        il = floor(xa(i));
        a  = xa(i) - il;
        xh(il+[1 2]) = xh(il+[1 2])+[1-a, a]';
    end
    % --- Compute -------------------------------------------------
    xk = (-gridsize:gridsize-1)'*d;
    K = exp(-0.5*(xk/h).^2);
    K = K / (sum(K)*d*n);
    f = ifft(fft(fftshift(K)).*fft([xh ;zeros(size(xh))]));
    f = real(f(1:gridsize));
    % --- Plot it -------------------------------------------------
    mm=min(opts.rfmax,max(ar));
    d = (0.8*(mm-1))/max(f);
    h1=plot(xx+mdang,d*f+1,opts.linecolor);
    set(h1,'LineWidth',opts.linewidth);
    hold on;
    %plot(0:180,maxrf,'m.-');
end

% Ri and Theta curves
if opts.rs>1
    % cc=bilbao(1:floor(256/8):256,:);
    cc=flip(parula(8));
    hold on
    ri=round(logspace(0.001,log10(opts.rfmax/opts.rs),8)*100)/100;
    leg=cell(1,8);
    for ii=1:8
        rf=linspace(1.01,opts.rs*ri(ii),500);
        tt=0.5*acos((cosh(log(rf))*cosh(log(opts.rs))-cosh(log(ri(ii))))./(sinh(log(rf))*sinh(log(opts.rs))));
        tt=real(tt);
        hh=plot(mdang+tt*180/pi,rf,mdang-tt*180/pi,rf);
        set(hh,'color',cc(ii,:));
        h1(ii)=hh(1);
        leg(ii)={['Ri:' num2str(ri(ii))]};
    end

    theta=10:10:80;
    for ii=1:8
        phi=linspace(0,theta(ii),500)*pi/180;
        tt=theta(ii)*pi/180;
        rf=((tan(2*tt)*(opts.rs^2-tan(phi).^2)-2*opts.rs*tan(phi))./(tan(2*tt)*(1-opts.rs^2*tan(phi).^2)-2*opts.rs*tan(phi))).^0.5;
        rf(rf<1)=exp(6);
        hh=plot(mdang+phi*180/pi,rf,mdang-phi*180/pi,rf);
        set(hh,'color',cc(ii,:));
        leg(ii)={[leg{ii} ' Theta:' num2str(theta(ii))]};
    end
    legend(h1,leg)
end

h1=plot(ang+mdang,ar,opts.pointcolor);
set(h1,'MarkerSize',opts.pointsize);
axis([mdang-90 mdang+90 1 opts.rfmax]);
xlabel('Orientation');
ylabel('Axial ratio');
if nargout<1
    title(['Theta:' num2str(mdang) ' F:' num2str(4*sang) ' Rfmean:' num2str(rfmean) ' Isym:' num2str(isym)]);
end
set(gca,'TickDir','out')
set(gca,'YScale','log');
%set(gca,'YTick',linspace(1,opts.rfmax,10))
set(gca,'YTick',round(100*logspace(0,log10(opts.rfmax),15))/100)
set(gca,'YMinorTick','off')
%set(gca,'YGrid','on')
hold off

end

