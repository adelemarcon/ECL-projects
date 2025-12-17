clear all; close all;

T_max = 5;
N_values = [125, 250];

for idx = 1:length(N_values)
    N = N_values(idx);
    h = T_max / N;
    t = 0:h:T_max;
    
    Y = zeros(1, N+1);
    Z = zeros(1, N+1);
    Y(1) = 0;
    Z(1) = 0;
    
    for n = 1:N
        Y(n+1) = Y(n) + h * (-50*Y(n) + exp(-t(n)^2));
        Z(n+1) = Z(n) + h * (50*Y(n) - 2*Z(n)^2);
    end
    
    subplot(1, 2, idx);
    plot(t, Y, 'b-', 'LineWidth', 1.5); hold on;
    plot(t, Z, 'r-', 'LineWidth', 1.5);
    xlabel('Temps t');
    ylabel('Concentration');
    title(sprintf('Euler explicite - N = %d (h = %.4f)', N, h));
    legend('y(t)', 'z(t)', 'Location', 'best');
    grid on;

    if N == 250
        fprintf('\nQuestion 2:\n');
        fprintf('Pour N = %d, z(5) = %.5f\n', N, Z(end));
        fprintf('Valeur attendue: 0.10778\n');
    end
end

fprintf('\n\nQuestion 3:\n');
fprintf('Pour approcher z(t=1000) avec le schéma d''Euler explicite:\n');
fprintf('- Le terme e^(-t^2) devient négligeable pour t > 5\n');
fprintf('- Il faudrait N = 1000/h pas de temps\n');
fprintf('- Pour h = 0.04: N = 25000 pas\n');
fprintf('- Pour h = 0.01: N = 100000 pas\n');
fprintf('- Le coût calcul devient prohibitif\n');
fprintf('- Le schéma explicite peut être instable pour grands t\n');

%% Question 4
T_max = 5;
h_values = [0.04, 0.01];

for idx = 1:length(h_values)
    h = h_values(idx);
    N = round(T_max / h);
    t = 0:h:T_max;
    
    % Initialize
    Y = zeros(1, N+1);
    Z = zeros(1, N+1);
    Y(1) = 0;
    Z(1) = 0;
    
    % Implicit Euler scheme
    for n = 1:N
        t_next = t(n+1);
        % Y equation (linear, direct solution)
        Y(n+1) = (Y(n) + h * exp(-t_next^2)) / (1 + 50*h);
        
        a = 2*h;
        b = 1;
        c = -Z(n) - 50*h*Y(n+1);
        
        discriminant = b^2 - 4*a*c;
        Z(n+1) = (-b + sqrt(discriminant)) / (2*a);
    end
    
    subplot(1, 2, idx);
    plot(t, Y, 'b-', 'LineWidth', 1.5); hold on;
    plot(t, Z, 'r-', 'LineWidth', 1.5);
    xlabel('Temps t');
    ylabel('Concentration');
    title(sprintf('Euler implicite - h = %.2f', h));
    legend('y(t)', 'z(t)', 'Location', 'best');
    grid on;
    
    fprintf('h = %.2f: z(5) = %.5f\n', h, Z(end));
end

%% Comparison with explicit Euler
fprintf('\n\nComparaison Euler explicite vs implicite:\n');

h_comp = 0.01;
N_comp = round(T_max / h_comp);
t_comp = 0:h_comp:T_max;

% Explicit Euler
Y_exp = zeros(1, N_comp+1);
Z_exp = zeros(1, N_comp+1);
for n = 1:N_comp
    Y_exp(n+1) = Y_exp(n) + h_comp * (-50*Y_exp(n) + exp(-t_comp(n)^2));
    Z_exp(n+1) = Z_exp(n) + h_comp * (50*Y_exp(n) - 2*Z_exp(n)^2);
end

% Implicit Euler
Y_imp = zeros(1, N_comp+1);
Z_imp = zeros(1, N_comp+1);
for n = 1:N_comp
    t_next = t_comp(n+1);
    Y_imp(n+1) = (Y_imp(n) + h_comp * exp(-t_next^2)) / (1 + 50*h_comp);
    a = 2*h_comp;
    b = 1;
    c = -Z_imp(n) - 50*h_comp*Y_imp(n+1);
    Z_imp(n+1) = (-b + sqrt(b^2 - 4*a*c)) / (2*a);
end

subplot(1, 2, 1);
plot(t_comp, Y_exp, 'b--', 'LineWidth', 1.5); hold on;
plot(t_comp, Y_imp, 'b-', 'LineWidth', 1.5);
xlabel('Temps t');
ylabel('y(t)');
title('Comparaison y(t) - h = 0.01');
legend('Explicite', 'Implicite');
grid on;

subplot(1, 2, 2);
plot(t_comp, Z_exp, 'r--', 'LineWidth', 1.5); hold on;
plot(t_comp, Z_imp, 'r-', 'LineWidth', 1.5);
xlabel('Temps t');
ylabel('z(t)');
title('Comparaison z(t) - h = 0.01');
legend('Explicite', 'Implicite');
grid on;

%% Question 5: z(t=1000) with implicit Euler
fprintf('\n\nQuestion 5: Approximation de z(1000) avec Euler implicite\n');

T_max_long = 1000;
h = 0.05;
N_long = round(T_max_long / h);

Y = 0;
Z = 0;

for n = 1:N_long
    t_next = n * h;
    Y = (Y + h * exp(-t_next^2)) / (1 + 50*h);
    a = 2*h;
    b = 1;
    c = -Z - 50*h*Y;
    Z = (-b + sqrt(b^2 - 4*a*c)) / (2*a);
end

fprintf('\nRésultat final:\n');
fprintf('z(1000) ≈ %.6f\n', Z);
fprintf('\nNote: La substance z atteint une valeur d''équilibre à long terme.\n');

%% Exercice 4

apo = 20000000;
R = 6.37e6;
G = 6.67e-11;
m = 5.97e24;
a = G*m;

h = 10
T = 48*24*60*60;
N = T/h

t = 0:h:T;
X1 = zeros(2,N+1);
X1(:,1) = [0;2e7+R];
V1 = zeros(2,N+1);
V1(:,1) = [-3000;0];
E = zeros(2,N+1);


for n = 1:N
        V1(:,n+1) = V(:,n) - h * a*X(:,n)/(norm(X(:,n),2)^3);
        X1(:,n+1) = X(:,n) + h * (V(:,n+1));
        E(:,n+1) = 0.5*m*(norm(V(:,n+1),2))^2;
        A = [1-(h^2)*a/(norm(X(:,n),2)^3) h;-h*a/(norm(X(:,n))^3) 1];
end

subplot(1,2,2)
    plot(t, E, 'r-', 'LineWidth', 1.5);
    xlabel('Temps t');
    ylabel('Energie méca');
    title(sprintf('Euler explicite - N = %d (h = %.4f)', N, h));
    grid on;

subplot(1,2,1)
    plot(X1(1,:), X1(2,:), 'b-', 'LineWidth', 1.5);
    xlabel('Position x');
    ylabel('Position y');
    title(sprintf('Euler explicite - N = %d (h = %.4f)', N, h));
    grid on;