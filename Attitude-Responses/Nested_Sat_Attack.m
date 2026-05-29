%% Nested_Sat_Attack (Figs. 3-7 in Manuscript)
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

load('main_gain_abar02_bbar02.mat')
global J Jr Jp Jy L Ktau Kf

%% ------------------- Initial Settings -------------------
tf  = 100;          % final time
ti  = 0.001;        % Runge-Kutta sample time
tspan = 0:ti:tf;
sample_size = size(tspan,2);

t  = 0;
x(:,1) = [0.025; 0; 0.025; 0; 0.025; 0]'; % phi, phidot, theta, thetadot, psi, psidot

delta1 = [((Jp-Jy)*dpsi(2)+J*wp(1))/Jr, ((Jp-Jy)*dpsi(1)+J*wp(2))/Jr];
delta2 = [((Jy-Jr)*dpsi(1)-J*wp(2))/Jp, ((Jy-Jr)*dpsi(2)-J*wp(1))/Jp];

nu1_L_min = (delta1(2) - ((Jp-Jy)*x(6,1)+J*wp(1))/Jr)/(delta1(2)-delta1(1)); % delta1 = min
nu1_L_max = ((((Jp-Jy)*x(6,1)+J*wp(1))/Jr) - delta1(1))/(delta1(2)-delta1(1)); % delta1 = min
nu2_L_min = (delta2(2) - ((Jy-Jr)*x(6,1)-J*wp(2))/Jp)/(delta2(2)-delta2(1)); % delta2 = min
nu2_L_max = ((((Jy-Jr)*x(6,1)-J*wp(2))/Jp) - delta2(2))/(delta2(2)-delta2(1)); % delta2 = max

nu1_U_min = (delta1(2) - ((Jp-Jy)*x(6,1)+J*wp(2))/Jr)/(delta1(2)-delta1(1)); % delta1 = min
nu1_U_max = ((((Jp-Jy)*x(6,1)+J*wp(2))/Jr) - delta1(1))/(delta1(2)-delta1(1)); % delta1 = min
nu2_U_min = (delta2(2) - ((Jy-Jr)*x(6,1)-J*wp(1))/Jp)/(delta2(2)-delta2(1)); % delta2 = min
nu2_U_max = ((((Jy-Jr)*x(6,1)-J*wp(1))/Jp) - delta2(2))/(delta2(2)-delta2(1)); % delta2 = max

h1_L = nu1_L_min * nu2_L_min;
h2_L = nu1_L_min * nu2_L_max;
h3_L = nu1_L_max * nu2_L_min;
h4_L = nu1_L_max * nu2_L_max;

h1_U = nu1_U_min * nu2_U_min;
h2_U = nu1_U_min * nu2_U_max;
h3_U = nu1_U_max * nu2_U_min;
h4_U = nu1_U_max * nu2_U_max;

rho1 = 0.5*sin(0)+0.5;
rho2 = 1-rho1;

h1 = h1_L*rho1 + h1_U*rho2;
h2 = h2_L*rho1 + h2_U*rho2;
h3 = h3_L*rho1 + h3_U*rho2;
h4 = h4_L*rho1 + h4_U*rho2;

U(:,1)        = (h1*K{1} + h2*K{2} + h3*K{3} + h4*K{4})*x(:,1);
Input_sig(:,1)= U(:,1);
h_interval = tau2; 
sensor_sampling = round(h_interval/ti);    

%% Attack signal generation
vec_att_a=zeros(1,sample_size-1);
vec_att_b=zeros(1,sample_size-1);

certain_t = 1;

for i = round(certain_t/ti)+1 : round((certain_t+(tf*abar))/ti)+1
    vec_att_a(1,i)=1;
end

start2 = certain_t + ((certain_t+(tf*abar))-certain_t)/2;
certain_t2 = start2+((certain_t+(tf*abar))-certain_t)*bbar;
for i = round(start2/ti)+1 : round(certain_t2/ti)+1
    vec_att_b(1,i)=1;
end

attack_a_temp = zeros(1,sample_size-1);
attack_b_temp = zeros(1,sample_size-1);

%% ------------------- Simulation -------------------
tkh_plus_h = 0;     % Sensor counter
data(1)=0;
Dn = 2;

for i = 1:sample_size-1
    %% ---------- Current Attack Signal ----------
    attack_sig_a = vec_att_a(1,i);
    attack_sig_b = vec_att_b(1,i);
    
    attack_a_temp(1,i)=attack_sig_a;
    attack_b_temp(1,i)=attack_sig_b;

    %% ---------- System Dynamics ----------
    f   = -tanh(gb*x(:,i));        % 6x1
    ome =  (0.1)*cos(ti*i);

    %% ---------- Sensor Sampling ----------
    if tkh_plus_h == sensor_sampling
        
        data(Dn)=ti*i; % count at updating input
        Dn=Dn+1;
        nu1_L_min = (delta1(2) - ((Jp-Jy)*x(6,i)+J*wp(1))/Jr)/(delta1(2)-delta1(1)); % delta1 = min
        nu1_L_max = ((((Jp-Jy)*x(6,i)+J*wp(1))/Jr) - delta1(1))/(delta1(2)-delta1(1)); % delta1 = min
        nu2_L_min = (delta2(2) - ((Jy-Jr)*x(6,i)-J*wp(2))/Jp)/(delta2(2)-delta2(1)); % delta2 = min
        nu2_L_max = ((((Jy-Jr)*x(6,i)-J*wp(2))/Jp) - delta2(2))/(delta2(2)-delta2(1)); % delta2 = max
        
        nu1_U_min = (delta1(2) - ((Jp-Jy)*x(6,i)+J*wp(2))/Jr)/(delta1(2)-delta1(1)); % delta1 = min
        nu1_U_max = ((((Jp-Jy)*x(6,i)+J*wp(2))/Jr) - delta1(1))/(delta1(2)-delta1(1)); % delta1 = min
        nu2_U_min = (delta2(2) - ((Jy-Jr)*x(6,i)-J*wp(1))/Jp)/(delta2(2)-delta2(1)); % delta2 = min
        nu2_U_max = ((((Jy-Jr)*x(6,i)-J*wp(1))/Jp) - delta2(2))/(delta2(2)-delta2(1)); % delta2 = max
        
        h_L{1} = nu1_L_min * nu2_L_min;
        h_L{2} = nu1_L_min * nu2_L_max;
        h_L{3} = nu1_L_max * nu2_L_min;
        h_L{4} = nu1_L_max * nu2_L_max;
        
        h_U{1} = nu1_U_min * nu2_U_min;
        h_U{2} = nu1_U_min * nu2_U_max;
        h_U{3} = nu1_U_max * nu2_U_min;
        h_U{4} = nu1_U_max * nu2_U_max;

        rho1 = 0.5*sin(ti*i)+0.5;
        rho2 = 1-rho1;
        
        h1 = h_L{1}*rho1 + h_U{1}*rho2;
        h2 = h_L{2}*rho1 + h_U{2}*rho2;
        h3 = h_L{3}*rho1 + h_U{3}*rho2;
        h4 = h_L{4}*rho1 + h_U{4}*rho2;    
        
        h_vec = [h1; h2; h3; h4];
        h_vec = max(0, min(1, h_vec));           % Individual clipping
        sum_h = sum(h_vec);
        if sum_h == 0
            h_vec = ones(4,1) / 4; 
        else
            h_vec = h_vec / sum_h;
        end
    
        q_h1    = h_vec(1);
        q_h2    = h_vec(2);
        q_h3    = h_vec(3);
        q_h4    = h_vec(4);
 
        q_attack_a = attack_sig_a;
        q_attack_b = attack_sig_b;

        q_f     = f;

        K_ome = q_h1*K{1} + q_h2*K{2} + q_h3*K{3} + q_h4*K{4};
       
        % Attack Exist
        U = sat((1 - q_attack_a)*(K_ome*x(:,i)) + q_attack_a*((1 - q_attack_b)*(K_ome*q_f) + q_attack_b*sat(K_ome*x(:,i),u20)),u0);
        
        % No Attack 
        % U = sat((K_ome*x(:,i)),u0);
    
        tkh_plus_h = 0;            
        pp = randperm(10);
        
    end
    %% ---------- System Integration ----------
    x(:,i+1) = rk7(x(:,i), U, ti, ome);

    %% ---------- Recording and Counter ----------
    tkh_plus_h = tkh_plus_h + 1;   % Sensor counter

    Input_sig(:,i+1) = U;
    temp_f(:,i)      = f;
    temp_ome(:,i)    = ome;
    
end
temp_f(:, i+1) = -tanh(gb*x(:,i));
temp_ome(:,i+1) = (0.1)*cos(ti*(i+1));
attack_a_temp(1,i+1) = 0;
attack_b_temp(1,i+1) = 0;
norm_x = sqrt(sum(x.^2, 1)); 

%%
% figure 1: state
figure()
plot(tspan,x(1,:),'r-','LineWidth',1.8);
hold on
plot(tspan,x(3,:),'b-','LineWidth',1.8);
plot(tspan,x(5,:),'g-','LineWidth',1.8);
xlim([0 tf]); ylim([-1.3 1.3]);
ylabel('Attitude Angle (rad)','interpreter','latex', 'FontSize',15);
leg1 = legend('$x_{1}$','$x_{3}$','$x_{5}$','interpreter','latex', 'FontSize',15);
set(leg1,'Interpreter','latex');
xlabel('Time (sec)','interpreter','latex', 'FontSize',15);
box on
grid on;

% figure 2: state
figure()
plot(tspan,x(2,:),'r--','LineWidth',1.8);
hold on
plot(tspan,x(4,:),'b--','LineWidth',1.8);
plot(tspan,x(6,:),'g--','LineWidth',1.8);
ylabel('Attitude Angular Velocity (rad/s)','interpreter','latex', 'FontSize',15);
leg1 = legend('$x_{2}$','$x_{4}$','$x_{6}$','interpreter','latex', 'FontSize',15);
set(leg1,'Interpreter','latex');
xlabel('Time (sec)','interpreter','latex', 'FontSize',15);
box on
grid on;

% figure 3: input
figure();
ax = gca;
hold(ax, 'on');
patch(ax, [1 round((certain_t+(tf*abar))/ti)*ti round((certain_t+(tf*abar))/ti)*ti 1], [-u0 -u0 u0 u0], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(ax, tspan, Input_sig(1,:), 'r', 'LineWidth', 1.8); 
plot(ax, tspan, Input_sig(2,:), 'b', 'LineWidth', 1.8);
plot(ax, tspan, Input_sig(3,:), 'g', 'LineWidth', 1.8);
plot(ax, tspan, Input_sig(4,:), 'k', 'LineWidth', 1.8);
yline(ax, u20, '--', 'C2A Attack Bound', 'Color', [0.7 0.1 0.1], 'LineWidth', 1.5, 'FontSize',15, 'Interpreter', 'latex', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(ax, -u20, '--', 'Color', [0.7 0.1 0.1], 'LineWidth', 1.5, 'FontSize',15, 'Interpreter', 'latex', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(ax, u0, '-.', 'Physical Actuator Limit', 'Color', [0.5 0.5 0.5], 'LineWidth', 2.0, 'FontSize', 15, 'Interpreter', 'latex', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(ax, -u0, '-.', 'Color', [0.5 0.5 0.5], 'LineWidth', 2.0, 'FontSize', 15, 'Interpreter', 'latex', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
xlabel(ax, 'Time (sec)','interpreter','latex', 'FontSize',15);
ylabel(ax, 'Control Input', 'Interpreter','latex', 'FontSize',15);
xlim([0 tf]); ylim([-8.5 8.5]);
% xstick([0 10 20 30 40 50 60 70 80 90 100])
legend('$u_{1}$','$u_{2}$','$u_{3}$','$u_{4}$','interpreter','latex', 'FontSize',15);
box on
grid on;

% figure 4: S2C attack
figure()
plot(tspan,temp_f(1,:),'r','LineWidth',1.8);
hold on 
plot(tspan,temp_f(2,:),'b','LineWidth',1.8);
plot(tspan,temp_f(3,:),'g','LineWidth',1.8);
plot(tspan,temp_f(4,:),'r--','LineWidth',1.8);
plot(tspan,temp_f(5,:),'b--','LineWidth',1.8);
plot(tspan,temp_f(6,:),'g--','LineWidth',1.8);
xlabel('Time (sec)','interpreter','latex', 'FontSize',15);
ylabel('$f(x)$','interpreter','latex', 'FontSize',15);
leg2 = legend('$f(x_{1})$','$f(x_{2})$','$f(x_{3})$','$f(x_{4})$','$f(x_{5})$','$f(x_{6})$','interpreter','latex', 'FontSize',15);
xlim([0 tf]); ylim([-0.12 0.12]);
set(leg2,'Interpreter','latex');
box on
grid on;

% figure 5: Attack Occurrence
figure()
plot(tspan,attack_a_temp(1,:),'r','LineWidth',1.5);
hold on
plot(tspan,attack_b_temp(1,:),'b--','LineWidth',1.5);
xlabel('Time (sec)','interpreter','latex', 'FontSize',15);
ylabel('Attack Signal','interpreter','latex', 'FontSize',15);
leg2 = legend('$\alpha(t)$', '$\beta(t)$','interpreter','latex', 'FontSize',15);
set(leg2,'Interpreter','latex');
box on
grid on;

% time = datestr(now, 'yyyy_mm_dd');
% name = ['tauM=' num2str(tau2),'abar=' num2str(abar),'bbar=' num2str(bbar),'TIME' num2str(time),'.mat'];
% save(name)
