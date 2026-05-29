%% Beta_Variation (Figs. 4 in Manuascript)
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
clear all;
close all;
clc

load('Sim_abar=0.2bbar=0.2TIME2026_05_27.mat')
norm_x_bbar02 = norm_x;
load('Sim_abar=0.2bbar=0.4TIME2026_05_27.mat')
norm_x_bbar04 = norm_x;
load('Sim_abar=0.2bbar=0.6TIME2026_05_27.mat')
norm_x_bbar06 = norm_x;
load('Sim_abar=0.2bbar=0.8TIME2026_05_27.mat')
norm_x_bbar08 = norm_x;
load('Sim_abar=0.2bbar=1TIME2026_05_27.mat')
norm_x_bbar1 = norm_x;

% figure 1: State Norm
figure()
hold on; 
plot(tspan, norm_x_bbar02, 'b-',  'LineWidth', 1.8);
plot(tspan, norm_x_bbar04, 'g--', 'LineWidth', 1.8); 
plot(tspan, norm_x_bbar06, 'm-.', 'LineWidth', 1.8); 
plot(tspan, norm_x_bbar08, 'c:',  'LineWidth', 1.8);
plot(tspan, norm_x_bbar1,  'r-',  'LineWidth', 1.8); 
xlim([0 tf]); 

max_all = max([max(norm_x_bbar02), max(norm_x_bbar04), max(norm_x_bbar06), max(norm_x_bbar08), max(norm_x_bbar1)]);
ylim_max = max_all * 1.2; 
ylim([0 ylim_max]); 
ylabel('$||x(t)||_2$', 'interpreter', 'latex', 'FontSize', 15);
xlabel('Time (sec)', 'interpreter', 'latex', 'FontSize', 15);
leg1 = legend('$\bar{\beta} = 0.2$', '$\bar{\beta} = 0.4$', '$\bar{\beta} = 0.6$', '$\bar{\beta} = 0.8$', '$\bar{\beta} = 1.0$');
set(leg1, 'Interpreter', 'latex', 'FontSize', 15, 'Location', 'northeast'); 
box on;
grid on;

















