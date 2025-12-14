%% Fonction logistique
clear all;
close all;
clc;

n = 2;
N = 10;
I = 1000;
lambda = zeros(1,N);
v= 0;
for i=1:N
    v = v + I/N;
    lambda(i) = v;
end

b = 1;
w11 = 0;
w12 = 1;
w21 = 1;
w22 = 0;
W = [w11, w12 ; w21, w22];
B = [0.5; 0.5];
s0 = [5 ; 10];

Phi2 = @(x) 1 ./ (1 + exp(-b*x));

ed = cell(1,N);
s = cell(1,N);
t = cell(1,N);
tspan = [0 0.1];
for i=1:N
    ed{i} = @(t,s) -lambda(i) * s + Phi2(W * s + B);
    [t{i}, s{i}] = ode45(ed{i}, tspan, s0);
end

figure('Position', [100 100 1400 500]);

for i = 1:N
    plot(t{1,i}, s{i}, 'LineWidth', 2);
    xlabel('Temps (t)', 'FontSize', 12);
    ylabel('États s_i(t)', 'FontSize', 12);
    grid on;
    legend(['s_1' num2str(i) '(t)'],['s_2' num2str(i) '(t)'], 'Location', 'best', 'FontSize', 11);
    hold on
end

hold off

%% Fonction positive
clear all;
close all;
clc;

n = 2;
b = 1;
w11 = 0;
w12 = 1;
w21 = 1;
w22 = 0;
W = [w11, w12 ; w21, w22];
B = [0.5; 0.5];

lambda1 = 0.1;
lambda2 = 1;
lambda3 = 10;

Phi1 =  @(x) max(0,x);

ed1 = @(t1, s1) -lambda1 * s1 + Phi1(W * s1 + B);
ed2 = @(t2, s2) -lambda2 * s2 + Phi1(W * s2 + B);
ed3 = @(t3, s3) -lambda3 * s3 + Phi1(W * s3 + B);
s0 = [0 ; 10];
tspan = [0 2];

[t1, s1] = ode45(ed1, tspan, s0);
[t2, s2] = ode45(ed2, tspan, s0);
[t3, s3] = ode45(ed3, tspan, s0);

figure('Position', [100 100 1400 500]);

% Graphique 1
subplot(1, 3, 1);
plot(t1, s1, 'LineWidth', 2);
xlabel('Temps (t)', 'FontSize', 12);
ylabel('États s_i(t)', 'FontSize', 12);
grid on;
legend('s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);

% Graphique 2
subplot(1, 3, 2);
plot(t2, s2, 'LineWidth', 2);
xlabel('Temps (t)', 'FontSize', 12);
ylabel('États s_i(t)', 'FontSize', 12);
grid on;
legend('s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);


% Graphique 3
subplot(1, 3, 3);
plot(t3, s3, 'LineWidth', 2);
xlabel('Temps (t)', 'FontSize', 12);
ylabel('États s_i(t)', 'FontSize', 12);
grid on;
legend('s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
