%% Feasibility_Analysis (Fig. 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2026 Seungyong Han, Jeonbuk National University
%
% This software/code is the intellectual property of Seungyong Han
% at Jeonbuk National University. It is provided "as is," without any 
% warranty of any kind. Users are granted permission to use, copy, modify, 
% and distribute this code for academic or research purposes, provided 
% that this copyright notice is retained in all copies or derivative works.
%
% By using this code, you agree that any resulting publications or 
% presentations will acknowledge its origin.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

% 1. Generate a grid for alpha and beta (from 0.1 to 1.0)
alpha_vals = 0.1:0.1:1.0;
beta_vals = 0.1:0.1:1.0;
[Alpha, Beta] = meshgrid(alpha_vals, beta_vals);

% 2. Define a map matrix indicating Feasible(1) / Infeasible(0) states
% Each row corresponds to beta = 0.1 to 1.0, and each column to alpha = 0.1 to 1.0.
Z = [
    1 1 1 1 1 0 0 0 0 0; % beta = 0.1
    1 1 1 1 1 0 0 0 0 0; % beta = 0.2
    1 1 1 1 1 1 0 0 0 0; % beta = 0.3
    1 1 1 1 1 1 1 0 0 0; % beta = 0.4
    1 1 1 1 1 1 1 1 1 0; % beta = 0.5
    1 1 1 1 1 1 1 1 1 1; % beta = 0.6
    1 1 1 1 1 1 1 1 1 1; % beta = 0.7
    1 1 1 1 1 1 1 1 1 1; % beta = 0.8
    1 1 1 1 1 1 1 1 1 1; % beta = 0.9
    1 1 1 1 1 1 1 1 1 1  % beta = 1.0
];

% 3. Extract indices
feas_idx = (Z == 1);
infeas_idx = (Z == 0);

% 4. Generate the plot
figure('Position', [100, 100, 600, 550], 'Color', 'w');
hold on;
grid on;
box on;

% Plot Feasible points (red empty circles)
p1 = plot(Alpha(feas_idx), Beta(feas_idx), 'ro', ...
    'MarkerSize', 7, 'LineWidth', 1.5, 'MarkerFaceColor', 'none');

% Plot Infeasible points (black crosses)
p2 = plot(Alpha(infeas_idx), Beta(infeas_idx), 'kx', ...
    'MarkerSize', 7, 'LineWidth', 1.5);

% 5. Axis settings (limits and ticks)
xlim([0 1.1]);
ylim([0 1.1]);
xticks(0:0.1:1); % Display X-axis ticks up to 1
yticks(0:0.1:1); % Display Y-axis ticks up to 1

% Set font, tick direction, and grid transparency
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16, ...
    'TickDir', 'out', 'GridColor', [0.85 0.85 0.85], 'GridAlpha', 0.5);

% 6. Add labels (using LaTeX interpreter)
xlabel('$\bar{\alpha}$', 'Interpreter', 'latex', 'FontSize', 17);
ylabel('$\bar{\beta}$', 'Interpreter', 'latex', 'FontSize', 17);

% 7. Legend settings
% Set text to have a colon (:) after the marker, like the original image
lgd = legend([p1, p2], {': feasible', ': infeasible'}, ...
    'Interpreter', 'latex', 'FontSize', 17, 'Orientation', 'horizontal');

% Position the legend outside the top-right corner of the plot
set(lgd, 'Position', [0.49 0.92 0.4 0.05], 'Units', 'normalized');

% Adjust the Axes size to ensure space for the legend
ax = gca;
ax.Position = [0.13 0.11 0.77 0.77];
hold off;