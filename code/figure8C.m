%% figure8C.m
% 
% Produce figure 8C
%
%% Description
%
% This script produces figure 8C. The figure displays the efficient unemployment rate in the United States, 1951--2019, under 3 different calibrations of the sufficient statistics:
% * with the recruiting cost calibrated to its baseline estimate
% * with the recruiting cost calibrated at 2/3 of the baseline estimate
% * with the recruiting cost calibrated at 4/3 of the baseline estimate
%
% The figure also displays the US unemployment rate as a benchmark.
%
%% Output
%
% * Figure 8C is saved as figure8C.pdf.
% * The underlying data are saved in figure8C.xlsx.
%

close all
clear
clc

%% --- Get data ---

% Get timeline
timeline = getTimeline();

% Get recessions dates
[startRecession, endRecession, nRecession] = getRecessionDate();

% Get unemployment rate
u = getUnemploymentRate();

% Get vacancy rate
v = getVacancyRate();

%% ---  Get sufficient statistics ---

% Get Beveridge elasticity
epsilon = getBeveridgeElasticity();

% Input the social value of nonwork estimated in section 5.2
zeta = 0.26;

% Input the recruiting cost estimated in section 5.3, and 2/3 and 4/3 of this value
kappa = 0.92; 
kappaLow = (2/3).*kappa;
kappaHigh = (4/3).*kappa;

%% --- Compute efficient unemployment rate for different recruiting costs ---

% Use estimate of Beveridge elasticity
uStar = computeEfficientUnemployment(epsilon, zeta, kappa, u, v);

% Use lower bound on Beveridge elasticity
uStarKappaLow = computeEfficientUnemployment(epsilon, zeta, kappaLow, u, v);

% Use upper bound on Beveridge elasticity
uStarKappaHigh = computeEfficientUnemployment(epsilon, zeta, kappaHigh, u, v);

%% --- Format figure & plot ---

formatFigure
formatPlot

%% --- Produce figure ---

figure(1)
clf
hold on

% Paint recession areas
for iRecession = 1 : nRecession
	area([startRecession(iRecession), endRecession(iRecession)], [2,2], areaSetting{:});
end

% Plot actual unemployment rate
plot(timeline, u, purpleSetting{:})

% Paint plausible interval for efficient unemployment rate
a = area(timeline, [uStarKappaLow, uStarKappaHigh - uStarKappaLow], 'LineStyle', 'none');
a(1).FaceAlpha = 0;
a(2).FaceAlpha = 0.2;
a(2).FaceColor = pink;

% Plot different efficient unemployment rates
plot(timeline, uStar, pinkSetting{:})
plot(timeline, uStarKappaLow, thinPinkSetting{:})
plot(timeline, uStarKappaHigh, thinPinkSetting{:})


% Populate axes
set(gca, xSetting{:})
set(gca, 'yLim', [0,0.12], 'yTick', [0:0.03:0.12], 'yTickLabel', [' 0%';' 3%';' 6%';' 9%';'12%'])
ylabel('Unemployment rate')

% Print figure
print('-dpdf', 'figure8C.pdf')

%% --- Save results ---

file = 'figure8C.xlsx';
sheet = 'Figure 8C';

% Write header
header = {'Date', 'Unemployment rate', 'Efficient unemployment rate', 'Efficient unemployment rate with low recruiting cost', 'Efficient unemployment rate with high recruiting cost'};
writecell(header, file, 'Sheet', sheet, 'WriteMode', 'replacefile')

% Write results
result = [timeline, u, uStar, uStarKappaLow, uStarKappaHigh];
writematrix(result, file, 'Sheet', sheet, 'WriteMode', 'append')

