clear all; close all; clc;

% Paramètres physiques
alpha = 5.10e-3;
g = 9.81;
v0 = 100;
theta = pi/4;

% Conditions initiales
x0 = 0;
y0 = 0;
vx0 = v0 * cos(theta);
vy0 = v0 * sin(theta);

% Vecteur d'état initial : Y = [x, y, vx, vy]
Y0 = [x0; y0; vx0; vy0];

fprintf('=== QUESTION 1 : Calcul de la trajectoire ===\n');

T = 5;
N = 1e5;
h = T/N;

% Y' = f(t, Y) où Y = [x, y, vx, vy]
f = @(t, Y) [
    Y(3);  % dx/dt = vx
    Y(4);  % dy/dt = vy
    -alpha * Y(3) * sqrt(Y(3)^2 + Y(4)^2);  % dvx/dt
    -alpha * Y(4) * sqrt(Y(3)^2 + Y(4)^2) - g  % dvy/dt
];

% Méthode RK4
tn = 0:h:T;
Yn = zeros(4, N+1);
Yn(:,1) = Y0;

for n = 1:N
    t_n = tn(n);
    t_n1 = tn(n+1);
    Y_n = Yn(:,n);
    
    % Calcul des coefficients RK4
    k1 = f(t_n, Y_n);
    k2 = f(t_n + h/2, Y_n + h*k1/2);
    k3 = f(t_n + h/2, Y_n + h*k2/2);
    k4 = f(t_n1 + h, Y_n + h*k3);
    
    % Mise à jour
    Yn(:,n+1) = Y_n + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end

% Position finale
x_star = Yn(1, N);
y_star = Yn(2, N);

fprintf('Position finale approchée :\n');
fprintf('  x* = %.6f m\n', x_star);
fprintf('  y* = %.6f m\n', y_star);
fprintf('  N = %d pas\n', N);
fprintf('  h = %.2e s\n\n', h);

fprintf('=== QUESTION 2 : Ordre de convergence ===\n');

% Différentes valeurs de N
N_values = [10, 11, 12, 20, 100, 1000, 10000];
positions_finales = zeros(length(N_values), 2);
h_values = zeros(size(N_values));

for i = 1:length(N_values)
    N_temp = N_values(i);
    h_temp = T/N_temp;
    h_values(i) = h_temp;
    
    tn_temp = 0:h_temp:T;
    Yn_temp = zeros(4, N_temp+1);
    Yn_temp(:,1) = Y0;
    
    for n = 1:N_temp
        t_n = tn_temp(n);
        Y_n = Yn_temp(:,n);
        
        k1 = f(t_n, Y_n);
        k2 = f(t_n + h_temp/2, Y_n + h_temp*k1/2);
        k3 = f(t_n + h_temp/2, Y_n + h_temp*k2/2);
        k4 = f(t_n + h_temp, Y_n + h_temp*k3);
        
        Yn_temp(:,n+1) = Y_n + (h_temp/6)*(k1 + 2*k2 + 2*k3 + k4);
    end
    
    positions_finales(i, 1) = Yn_temp(1, end);
    positions_finales(i, 2) = Yn_temp(2, end);
end

% Calcul des erreurs (par rapport à la solution la plus fine)
x_ref = positions_finales(end, 1);
y_ref = positions_finales(end, 2);

erreurs_x = abs(positions_finales(:,1) - x_ref);
erreurs_y = abs(positions_finales(:,2) - y_ref);
erreurs_totales = sqrt(erreurs_x.^2 + erreurs_y.^2);

% Calcul de l'ordre de convergence
ordres = zeros(length(N_values)-1, 1);
for i = 1:length(N_values)-1
    if erreurs_totales(i) > 0 && erreurs_totales(i+1) > 0
        ordres(i) = log(erreurs_totales(i)/erreurs_totales(i+1)) / ...
                    log(h_values(i)/h_values(i+1));
    end
end

fprintf('N\t\th\t\tx*\t\ty*\t\tErreur\t\tOrdre\n');
fprintf('-------------------------------------------------------------------\n');
for i = 1:length(N_values)
    fprintf('%.0e\t%.2e\t%.4f\t%.4f\t%.2e', ...
        N_values(i), h_values(i), positions_finales(i,1), ...
        positions_finales(i,2), erreurs_totales(i));
    if i < length(N_values)
        fprintf('\t%.2f', ordres(i));
    end
    fprintf('\n');
end

fprintf('\nOrdre de convergence moyen : %.2f (théorique : 4)\n', mean(ordres));

% Précision pour 1 cm
precision_requise = 0.01;  % 1 cm = 0.01 m
idx_precision = find(erreurs_totales <= precision_requise, 1, 'first');
if ~isempty(idx_precision)
    fprintf('Pour une précision de 1 cm, il faut N >= %.0e\n\n', N_values(idx_precision));
else
    fprintf('Aucune valeur de N testée n''atteint la précision de 1 cm\n\n');
end

fprintf('=== QUESTION 3 : Temps d''impact au sol ===\n');

% Recherche du temps d'impact (y = 0) en affichant la trajectoire complète
% Il faut prolonger le calcul jusqu'à ce que y devienne négatif
T_max = 15;  % Temps maximal de simulation
N_impact = 5e4;
h_impact = T_max/N_impact;

tn_impact = 0:h_impact:T_max;
Yn_impact = zeros(4, N_impact+1);
Yn_impact(:,1) = Y0;

for n = 1:N_impact
    t_n = tn_impact(n);
    Y_n = Yn_impact(:,n);
    
    k1 = f(t_n, Y_n);
    k2 = f(t_n + h_impact/2, Y_n + h_impact*k1/2);
    k3 = f(t_n + h_impact/2, Y_n + h_impact*k2/2);
    k4 = f(t_n + h_impact, Y_n + h_impact*k3);
    
    Yn_impact(:,n+1) = Y_n + (h_impact/6)*(k1 + 2*k2 + 2*k3 + k4);
    
    % Détection de l'impact (y < 0)
    if Yn_impact(2, n+1) < 0 && n > 1
        % Interpolation linéaire pour trouver le temps exact
        y1 = Yn_impact(2, n);
        y2 = Yn_impact(2, n+1);
        t1 = tn_impact(n);
        t2 = tn_impact(n+1);
        T0 = t1 - y1 * (t2 - t1) / (y2 - y1);
        
        fprintf('Temps d''impact T0 = %.6f s\n', T0);
        fprintf('Position x à l''impact = %.4f m\n', Yn_impact(1, n));
        
        % Tronquer les données
        Yn_impact = Yn_impact(:, 1:n);
        tn_impact = tn_impact(1:n);
        break;
    end
end

% Vérification de l'ordre de convergence pour T0
N_values_T0 = [1e3, 2e3, 5e3, 1e4, 2e4, 5e4];
T0_values = zeros(size(N_values_T0));

for i = 1:length(N_values_T0)
    N_temp = N_values_T0(i);
    h_temp = T_max/N_temp;
    
    Yn_temp = zeros(4, N_temp+1);
    Yn_temp(:,1) = Y0;
    
    for n = 1:N_temp
        t_n = n*h_temp - h_temp;
        Y_n = Yn_temp(:,n);
        
        k1 = f(t_n, Y_n);
        k2 = f(t_n + h_temp/2, Y_n + h_temp*k1/2);
        k3 = f(t_n + h_temp/2, Y_n + h_temp*k2/2);
        k4 = f(t_n + h_temp, Y_n + h_temp*k3);
        
        Yn_temp(:,n+1) = Y_n + (h_temp/6)*(k1 + 2*k2 + 2*k3 + k4);
        
        if Yn_temp(2, n+1) < 0 && n > 1
            y1 = Yn_temp(2, n);
            y2 = Yn_temp(2, n+1);
            t1 = (n-1)*h_temp;
            t2 = n*h_temp;
            T0_values(i) = t1 - y1 * (t2 - t1) / (y2 - y1);
            break;
        end
    end
end

% Calcul de l'ordre de convergence pour T0
T0_ref = T0_values(end);
erreurs_T0 = abs(T0_values - T0_ref);
h_values_T0 = T_max ./ N_values_T0;

ordres_T0 = zeros(length(N_values_T0)-1, 1);
for i = 1:length(N_values_T0)-1
    if erreurs_T0(i) > 0 && erreurs_T0(i+1) > 0
        ordres_T0(i) = log(erreurs_T0(i)/erreurs_T0(i+1)) / ...
                       log(h_values_T0(i)/h_values_T0(i+1));
    end
end

fprintf('\nOrdre de convergence pour T0 :\n');
fprintf('N\t\tT0\t\tErreur\t\tOrdre\n');
fprintf('------------------------------------------------\n');
for i = 1:length(N_values_T0)
    fprintf('%.0e\t%.6f\t%.2e', N_values_T0(i), T0_values(i), erreurs_T0(i));
    if i < length(N_values_T0)
        fprintf('\t%.2f', ordres_T0(i));
    end
    fprintf('\n');
end
fprintf('\nOrdre de convergence moyen pour T0 : %.2f\n', mean(ordres_T0));

% ========================================================================
% VISUALISATIONS
% ========================================================================

% Figure 1 : Trajectoire
figure('Position', [100 100 1200 400]);

subplot(1,3,1);
plot(Yn_impact(1,:), Yn_impact(2,:), 'b-', 'LineWidth', 2);
grid on;
xlabel('x (m)');
ylabel('y (m)');
title('Trajectoire de la balle');
axis equal;

% Figure 2 : Ordre de convergence pour la position finale
subplot(1,3,2);
loglog(h_values, erreurs_totales, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8);
hold on;
loglog(h_values, h_values.^4 * erreurs_totales(1)/h_values(1)^4, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Pas de temps h (s)');
ylabel('Erreur (m)');
title('Convergence de la position finale');
legend('Erreur numérique', 'Pente O(h^4)', 'Location', 'best');

% Figure 3 : Ordre de convergence pour T0
subplot(1,3,3);
loglog(h_values_T0, erreurs_T0, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8);
hold on;
loglog(h_values_T0, h_values_T0.^4 * erreurs_T0(1)/h_values_T0(1)^4, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Pas de temps h (s)');
ylabel('Erreur (s)');
title('Convergence du temps d''impact T_0');
legend('Erreur numérique', 'Pente O(h^4)', 'Location', 'best');

fprintf('\n=== FIN DES CALCULS ===\n');



% On utilise T0 calculé à la question précédente et theta = pi/4
T0_final = T0_ref;

% ========================================================================
% QUESTION 1 : Longueur de la trajectoire par la méthode des trapèzes
% ========================================================================
fprintf('=== QUESTION 1 : Longueur de la trajectoire ===\n');

% Fonction pour calculer la longueur de la trajectoire
calcul_longueur = @(N_trap, T_final) calculer_longueur_trajectoire(...
    alpha, g, v0, theta, T_final, N_trap, f);

% Test avec différentes valeurs de N
N_trap_values = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
longueurs = zeros(size(N_trap_values));

fprintf('Calcul de la longueur de la trajectoire sur [0, T0]...\n');
fprintf('T0 = %.6f s\n\n', T0_final);

for i = 1:length(N_trap_values)
    longueurs(i) = calcul_longueur(N_trap_values(i), T0_final);
end

% Calcul des erreurs et ordre de convergence
L_ref = longueurs(end);
erreurs_L = abs(longueurs - L_ref);
h_trap = T0_final ./ N_trap_values;

ordres_L = zeros(length(N_trap_values)-1, 1);
for i = 1:length(N_trap_values)-1
    if erreurs_L(i) > 0 && erreurs_L(i+1) > 0
        ordres_L(i) = log(erreurs_L(i)/erreurs_L(i+1)) / ...
                      log(h_trap(i)/h_trap(i+1));
    end
end

fprintf('N\t\th\t\tLongueur (m)\tErreur (m)\tOrdre\n');
fprintf('----------------------------------------------------------------\n');
for i = 1:length(N_trap_values)
    fprintf('%d\t\t%.4e\t%.6f\t%.2e', ...
        N_trap_values(i), h_trap(i), longueurs(i), erreurs_L(i));
    if i < length(N_trap_values)
        fprintf('\t\t%.2f', ordres_L(i));
    end
    fprintf('\n');
end

fprintf('\nLongueur de la trajectoire : L ≈ %.6f m\n', L_ref);
fprintf('Ordre de convergence moyen : %.2f (théorique : 2 pour trapèzes)\n\n', mean(ordres_L));

% ========================================================================
% QUESTION 2 : Portée horizontale maximale (méthode du nombre d'or)
% ========================================================================
fprintf('=== QUESTION 2 : Portée horizontale maximale ===\n');

% Fonction objectif : portée horizontale (à maximiser)
% On cherche theta qui maximise la distance x à l'impact
fonction_portee = @(theta_test) calculer_portee(alpha, g, v0, theta_test, f);

% Méthode du nombre d'or (Golden Section Search)
% On cherche le maximum dans [0, pi/2]
phi = (1 + sqrt(5)) / 2;  % Nombre d'or
tolerance = 1e-6;
a = 0;
b = pi/2;

% On transforme en problème de minimisation (chercher -portée)
fonction_a_minimiser = @(theta_test) -fonction_portee(theta_test);

fprintf('Recherche de l''angle optimal par la méthode du nombre d''or...\n');

iter = 0;
max_iter = 100;

while (b - a) > tolerance && iter < max_iter
    c = b - (b - a) / phi;
    d = a + (b - a) / phi;
    
    if fonction_a_minimiser(c) < fonction_a_minimiser(d)
        b = d;
    else
        a = c;
    end
    
    iter = iter + 1;
end

theta_optimal = (a + b) / 2;
portee_max = fonction_portee(theta_optimal);

fprintf('\nRésultats de l''optimisation :\n');
fprintf('  Angle optimal θ* = %.6f rad = %.2f°\n', theta_optimal, theta_optimal*180/pi);
fprintf('  Portée maximale = %.6f m\n', portee_max);
fprintf('  Nombre d''itérations : %d\n', iter);

% Comparaison avec theta = pi/4
portee_pi4 = fonction_portee(pi/4);
fprintf('\nComparaison :\n');
fprintf('  Portée avec θ = π/4 : %.6f m\n', portee_pi4);
fprintf('  Gain avec θ* : %.6f m (%.2f%%)\n', ...
    portee_max - portee_pi4, 100*(portee_max - portee_pi4)/portee_pi4);

% ========================================================================
% VISUALISATIONS SUPPLÉMENTAIRES
% ========================================================================

% Figure 4 : Convergence de la longueur
figure('Position', [100 100 1200 400]);

subplot(1,3,1);
loglog(h_trap, erreurs_L, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8);
hold on;
loglog(h_trap, h_trap.^2 * erreurs_L(1)/h_trap(1)^2, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Pas h (s)');
ylabel('Erreur (m)');
title('Convergence de la longueur (trapèzes)');
legend('Erreur numérique', 'Pente O(h^2)', 'Location', 'best');

% Graphique de la portée en fonction de l'angle
subplot(1,3,2);
theta_range = linspace(0, pi/2, 100);
portee_range = zeros(size(theta_range));
for i = 1:length(theta_range)
    portee_range(i) = fonction_portee(theta_range(i));
end
plot(theta_range*180/pi, portee_range, 'b-', 'LineWidth', 2);
hold on;
plot(theta_optimal*180/pi, portee_max, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
plot(45, portee_pi4, 'gs', 'MarkerSize', 10, 'LineWidth', 2);
grid on;
xlabel('Angle θ (°)');
ylabel('Portée (m)');
title('Portée en fonction de l''angle de lancement');
legend('Portée(θ)', 'θ* optimal', 'θ = 45°', 'Location', 'best');

% Comparaison des trajectoires
subplot(1,3,3);
% Trajectoire avec theta = pi/4
[x_pi4, y_pi4] = calculer_trajectoire_complete(alpha, g, v0, pi/4, f, 5000);
% Trajectoire avec theta optimal
[x_opt, y_opt] = calculer_trajectoire_complete(alpha, g, v0, theta_optimal, f, 5000);

plot(x_pi4, y_pi4, 'g-', 'LineWidth', 2);
hold on;
plot(x_opt, y_opt, 'r-', 'LineWidth', 2);
grid on;
xlabel('x (m)');
ylabel('y (m)');
title('Comparaison des trajectoires');
legend('θ = 45°', sprintf('θ* = %.2f°', theta_optimal*180/pi), 'Location', 'best');
axis equal;

fprintf('\n=== FIN EXERCICE 2 ===\n');

% ========================================================================
% FONCTIONS AUXILIAIRES
% ========================================================================

function L = calculer_longueur_trajectoire(alpha, g, v0, theta, T_final, N, f)
    % Calcule la longueur de la trajectoire par la méthode des trapèzes
    % L = int_0^T sqrt(x'(t)^2 + y'(t)^2) dt
    
    h = T_final / N;
    Y0 = [0; 0; v0*cos(theta); v0*sin(theta)];
    
    % Résolution avec RK4
    Y = Y0;
    t = 0;
    vitesses = zeros(N+1, 1);
    vitesses(1) = sqrt(Y(3)^2 + Y(4)^2);
    
    for n = 1:N
        k1 = f(t, Y);
        k2 = f(t + h/2, Y + h*k1/2);
        k3 = f(t + h/2, Y + h*k2/2);
        k4 = f(t + h, Y + h*k3);
        
        Y = Y + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
        t = t + h;
        vitesses(n+1) = sqrt(Y(3)^2 + Y(4)^2);
    end
    
    % Méthode des trapèzes pour l'intégrale
    L = h * (vitesses(1)/2 + sum(vitesses(2:end-1)) + vitesses(end)/2);
end

function portee = calculer_portee(alpha, g, v0, theta, f)
    % Calcule la portée horizontale pour un angle donné
    
    T_max = 20;
    N = 10000;
    h = T_max / N;
    Y0 = [0; 0; v0*cos(theta); v0*sin(theta)];
    
    Y = Y0;
    t = 0;
    
    for n = 1:N
        k1 = f(t, Y);
        k2 = f(t + h/2, Y + h*k1/2);
        k3 = f(t + h/2, Y + h*k2/2);
        k4 = f(t + h, Y + h*k3);
        
        Y_new = Y + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
        
        % Détection de l'impact
        if Y_new(2) < 0 && Y(2) >= 0
            % Interpolation linéaire
            portee = Y(1) - Y(2) * (Y_new(1) - Y(1)) / (Y_new(2) - Y(2));
            return;
        end
        
        Y = Y_new;
        t = t + h;
    end
    
    portee = Y(1);  % Si pas d'impact détecté
end

function [x, y] = calculer_trajectoire_complete(alpha, g, v0, theta, f, N)
    % Calcule la trajectoire complète jusqu'à l'impact
    
    T_max = 20;
    h = T_max / N;
    Y0 = [0; 0; v0*cos(theta); v0*sin(theta)];
    
    x = zeros(N+1, 1);
    y = zeros(N+1, 1);
    x(1) = Y0(1);
    y(1) = Y0(2);
    
    Y = Y0;
    t = 0;
    
    for n = 1:N
        k1 = f(t, Y);
        k2 = f(t + h/2, Y + h*k1/2);
        k3 = f(t + h/2, Y + h*k2/2);
        k4 = f(t + h, Y + h*k3);
        
        Y = Y + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
        t = t + h;
        
        x(n+1) = Y(1);
        y(n+1) = Y(2);
        
        % Arrêt si impact détecté
        if Y(2) < 0 && n > 1
            x = x(1:n+1);
            y = y(1:n+1);
            return;
        end
    end
end