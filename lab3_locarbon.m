% Lab 3 Tensile Strength of Steel
% Data collected 20 May 2022 in Upson I Civil Engineering Laboratory, UND.
%
% Requires: 
%  COLORS.M from CMU: https://github.com/jkitchin/matlab-cmu/blob/master/%2Bcmu/colors.m
%  SHADE.M by J.M. Tordera (Matlab Central): https://www.mathworks.com/matlabcentral/fileexchange/69652-filled-area-plot

% Last modified 27 May 2022 // MATLAB 9.9.0.1570001 (R2020b) Update 4 Win10
% David T. Wang (david.wang@und.edu) + Summer 2022 CE 411 Group 4 Members

%% Load Data

data = readmatrix('strainstress_locarbon.txt');

% Filter to remove duplicate entries in the x-axis
[~,idx]=unique(data(:,1),'rows','first');
data=data(sort(idx),:);

figure(2); clf;
plot(data(:,1), data(:,2), 'r-'); hold on;

title('Low-Carbon Steel')
ylabel('Stress (psi)')
xlabel('Strain (in/in)')

xlim([0 0.9])
ylim([0 90000])

ax = gca();
ax.YAxis.Exponent = 0
xtickformat('%.2f')
ytickformat('%,.0f')

ax.XRuler.TickLength = [.02 .01];
ax.YRuler.TickLength = [.02 .01];

PL = [0.1103, 50415];
EL = [0.1179, 54150];

elasidx = [data(:,1)<=EL(1)];

% Integration
shade(data(:,1), data(:,2), 'FillAlpha', [0.1]) % modulus of toughness
shade(data(elasidx,1), data(elasidx,2), 'FillAlpha', [0.3]) % modulus of resilience

% shade([0.1:0.1:1]' , [0.1:0.1:1]' *1e5)
% shade(dataHI(propidx,1),ones(length(dataHI(propidx,1)),1),dataHI(propidx,1),dataHI(propidx,2),'FillType',[1 2;2 1]);


% Proportional Limit
% PL = [0.135943, 114771];

% plot([PL(1) PL(1)], [0 PL(2)], 'k--')

E = B(2);

% Elastic Modulus
proprng = data([data(:,1)>=0.040&data(:,1)<=0.110],:); %data in proportional range
B = [ones(length(proprng),1) proprng(:,1)]\proprng(:,2); % [b m]'

xp = [0:0.05:0.15]';
plot(xp,[ones(length(xp),1) xp]*B,'k--');

xint = -B(1)/B(2)

% Find yield stress based on 0.2% strain offset (x-intercept = 0.002)
xy = [0:0.05:0.2]';
yy = xy*E - E*(0.002+xint);
%plot(xy, yy, 'k-')
% Prof said don't need to do this.  Just pick the yield point off the plot.

% Ultimate strength (maximum)
Fu = [data(find(data(:,2)==max(data(:,2))),1), max(data(:,2))];

% Fracture strength (end)
Ff = data(end,:);

% Upper yield stress
Yu = [0.1423, 57660];

% Lower yield stress
Yl = [0.1938, 56000];

%% Annotations

plot(Fu(1), Fu(2), 'k.')
plot(Ff(1), Ff(2), 'k.')
plot(EL(1), EL(2), 'k.')
plot(Yu(1), Yu(2), 'k.')
plot(Yl(1), Yl(2), 'k.')
plot(PL(1), PL(2), 'k.')

plot(Fu(1), Fu(2), 'ko')
plot(Ff(1), Ff(2), 'ko')
plot(EL(1), EL(2), 'ko')
plot(Yu(1), Yu(2), 'ko')
plot(Yl(1), Yl(2), 'ko')
plot(PL(1), PL(2), 'ko')


text(Fu(1), Fu(2)+500, 'ultimate stress', ...
    'FontSize', 8, ...
    'Color', 'Black', ...
    'VerticalAlign', 'bottom', ...
    'HorizontalAlign', 'center')
text(Ff(1)-0.01, Ff(2), 'fracture stress', ...
    'FontSize', 8, ...
    'Color', 'Black', ...
    'VerticalAlign', 'top', ...
    'HorizontalAlign', 'right')
text(EL(1)+0.01, EL(2)+500, 'elastic limit', ...
    'FontSize', 8, ...
    'Color', 'Black', ...
    'VerticalAlign', 'top', ...
    'HorizontalAlign', 'left')
text(Yu(1)+0.01, Yu(2)+500, 'upper yield point', ...
    'FontSize', 8, ...
    'Color', 'Black', ...
    'VerticalAlign', 'bottom', ...
    'HorizontalAlign', 'left')
text(Yl(1)+0.01, Yl(2), 'lower yield point', ...
    'FontSize', 8, ...
    'Color', 'Black', ...
    'VerticalAlign', 'middle', ...
    'HorizontalAlign', 'left')
text(PL(1)+0.01, PL(2), 'proportional limit', ...
    'FontSize', 8, ...
    'Color', 'Black', ...
    'VerticalAlign', 'top', ...
    'HorizontalAlign', 'left')

text(0.67, 30000, ['\sigma_u = ' num2str(Fu(2), '%.0f') ' psi'], ...
    'Color', 'Black', ...
    'HorizontalAlign', 'left')
text(0.67, 25000, ['\sigma_f = ' num2str(Ff(2), '%.0f') ' psi'], ...
    'Color', 'Black', ...
    'HorizontalAlign', 'left')
text(0.67, 20000, ['\sigma_y = ' num2str(Yu(2), '%.0f') ' psi'], ...
    'Color', 'Black', ...
    'HorizontalAlign', 'left')
text(0.67, 15000, ['\sigma_{pl} = ' num2str(PL(2), '%.0f') ' psi'], ...
    'Color', 'Black', ...
    'HorizontalAlign', 'left')

% grid on
% axis square

mod_of_elast = E;

mod_of_tough = cumtrapz(data(:,1), data(:,2)); % modulus of toughness: total area under stress-strain curve.
mod_of_tough = mod_of_tough(end); % take final value
mod_of_resil = cumtrapz(data(elasidx,1), data(elasidx,2)); % modulus of resilience = area under elastic region.
mod_of_resil = mod_of_resil(end); % take final value

text(0.2, 70000, ['Modulus of elasticity = ' num2str(E, '%.0f') ' psi'], ...
    'Color', 'Black', ...
    'HorizontalAlign', 'left')
text(0.4, 50000, ['Modulus of toughness = ' num2str(mod_of_tough, '%.0f') ' psi'], ...
    'Color', colors('international orange'), ...
    'HorizontalAlign', 'left')
text(0.1, 10000, ['Modulus of resilience = ' num2str(mod_of_resil, '%.0f') ' psi'], ...
    'Color', colors('dark pastel purple'), ...
    'HorizontalAlign', 'left')

% Region labels
plot([EL(1) EL(1)], [0 EL(2)], 'k--')
plot([Yu(1) Yu(1)], [0 Yu(2)], 'k--')
plot([Yl(1) Yl(1)], [0 Yl(2)], 'k--')
plot([Fu(1) Fu(1)], [0 Fu(2)], 'k--')

text(mean([0 EL(1)]), 5000, 'elastic region', ...
    'FontSize', 8, ...
    'Rotation', 80, ...
    'FontAngle', 'italic', ...
    'Color', 'Black', ...
    'VerticalAlign', 'middle', ...
    'HorizontalAlign', 'left')
text(mean([Yu(1) Yl(1)]), 5000, 'yielding', ...
    'FontSize', 8, ...
    'Rotation', 90, ...
    'FontAngle', 'italic', ...
    'Color', 'Black', ...
    'VerticalAlign', 'middle', ...
    'HorizontalAlign', 'left')
text(mean([Yl(1) Fu(1)]), 5000, 'strain hardening', ...
    'FontSize', 8, ...
    'Rotation', 0, ...
    'FontAngle', 'italic', ...
    'Color', 'Black', ...
    'VerticalAlign', 'middle', ...
    'HorizontalAlign', 'center')
text(mean([Fu(1) Ff(1)]), 5000, 'necking', ...
    'FontSize', 8, ...
    'Rotation', 0, ...
    'FontAngle', 'italic', ...
    'Color', 'Black', ...
    'VerticalAlign', 'middle', ...
    'HorizontalAlign', 'center')

%% Save as pdf

set(gcf(), 'paperpositionmode','auto');
print(gcf(), '-dpdf', '-loose', 'Fig 2 - Low Carbon.pdf');