clear all; close all; clc

% =========================================================================
% EXERCICE 3 : INJECTION TRANS-LUNAIRE
% =========================================================================

clear all; close all; clc;

% -------------------------------------------------------------------------
% DONNÉES PHYSIQUES
% -------------------------------------------------------------------------
RT = 6.37e6;           % Rayon de la Terre (m)
R = 3.84e8;            % Distance Terre-Lune (m)
v0 = 7.60e3;           % Vitesse initiale (m/s)
omega = 2.66e-6;       % Vitesse angulaire Lune (rad/s)
GMT = 3.99e14;         % Constante gravitationnelle Terre (m³/s²)
GML = 4.91e12;         % Constante gravitationnelle Lune (m³/s²)

% Conditions initiales
h0 = 6e5
r0 = h0 + RT;           % Rayon initial (m)
theta0 = 1.27*pi;      % Angle initial (rad)
Delta_v0 = 3200;       % Incrément de vitesse (m/s)

% Paramètres de simulation
T = 3 * 24 * 3600;     % Durée totale : 3 jours (s)
h = 10;                % Pas de temps (s)
N = floor(T/h);        % Nombre d'itérations

% -------------------------------------------------------------------------
% TÂCHE 1 : SCHÉMA RK-4 POUR LA TRAJECTOIRE
% -------------------------------------------------------------------------
fprintf('=== TÂCHE 1 : Calcul de la trajectoire avec RK-4 ===\n');

% Position initiale du satellite
x0 = r0 * cos(theta0);
y0 = r0 * sin(theta0);

% Vitesse initiale (vitesse circulaire + Delta_v)
vx0 = -(v0 + Delta_v0) * sin(theta0);
vy0 = (v0 + Delta_v0) * cos(theta0);

% Vecteur d'état initial : [x, y, vx, vy]
Y0 = [x0; y0; vx0; vy0];

% Fonction dérivée : système d'équations différentielles
f = @(t, Y) trajectoire_derivee(t, Y, GMT, GML, R, omega);

% Résolution par RK-4
[t, Y] = RK4(f, 0, T, Y0, h);

% Position finale
x_final = Y(end, 1:2);
distance_finale = norm(x_final);

fprintf('Distance finale du centre de la Terre : %.3e m\n', distance_finale);
fprintf('R11 ≈ %.3e m\n\n', distance_finale);

% -------------------------------------------------------------------------
% TÂCHE 2 : DISTANCE MINIMALE À LA LUNE
% -------------------------------------------------------------------------
fprintf('=== TÂCHE 2 : Distance minimale à la Lune ===\n');

% Position de la Lune au cours du temps
xL = R * cos(omega * t);
yL = R * sin(omega * t);

% Calcul des distances satellite-Lune
distances_lune = zeros(length(t), 1);
for i = 1:length(t)
    pos_satellite = [Y(i,1), Y(i,2)];
    pos_lune = [xL(i), yL(i)];
    distances_lune(i) = norm(pos_satellite - pos_lune);
end

% Distance minimale
delta = min(distances_lune);
fprintf('Distance minimale à la Lune : %.3e m\n', delta);
fprintf('R12 ≈ %.3e m\n\n', delta);

% -------------------------------------------------------------------------
% TÂCHE 3 : OPTIMISATION DE Delta_v
% -------------------------------------------------------------------------
fprintf('=== TÂCHE 3 : Optimisation de Delta_v ===\n');

% Fonction objectif : distance minimale à la Lune
objectif = @(dv) calculer_distance_min_lune(dv, theta0, r0, v0, ...
                                             GMT, GML, R, omega, T, h);

% Méthode de la section dorée pour minimiser la distance
a = 3000;  % Borne inférieure (m/s)
b = 3200;  % Borne supérieure (m/s)
tol = 1;   % Tolérance (m/s)
max_iter = 15;

[Delta_v_opt, d_min] = section_doree(objectif, a, b, tol, max_iter);

fprintf('Delta_v optimal : %.2f m/s\n', Delta_v_opt);
fprintf('Distance minimale correspondante : %.3e m\n', d_min);
fprintf('R13 ≈ %.2f m/s\n\n', Delta_v_opt);

% -------------------------------------------------------------------------
% TÂCHE 4 : OPTIMISATION DE L'ANGLE theta
% -------------------------------------------------------------------------
fprintf('=== TÂCHE 4 : Optimisation de l''angle theta ===\n');

% Fonction objectif pour theta
objectif_theta = @(theta) calculer_distance_min_lune(Delta_v_opt, theta, ...
                                                      r0, v0, GMT, GML, R, ...
                                                      omega, T, h);

% Recherche sur l'intervalle [0, 2*pi]
a_theta = 0;
b_theta = 2*pi;
tol_theta = 0.01;

[theta_opt, d_min_theta] = section_doree(objectif_theta, a_theta, ...
                                          b_theta, tol_theta, max_iter);

fprintf('Angle theta optimal : %.4f rad (%.2f degrés)\n', ...
        theta_opt, theta_opt*180/pi);
fprintf('Distance minimale correspondante : %.3e m\n', d_min_theta);
fprintf('R14 ≈ %.4f rad\n\n', theta_opt);

% -------------------------------------------------------------------------
% VISUALISATION
% -------------------------------------------------------------------------
fprintf('=== Génération des graphiques ===\n');

% Trajectoire avec paramètres optimaux
Y0_opt = [r0*cos(theta_opt); r0*sin(theta_opt); 
          -(v0+Delta_v_opt)*sin(theta_opt); (v0+Delta_v_opt)*cos(theta_opt)];
[t_opt, Y_opt] = RK4(f, 0, T, Y0_opt, h);

figure('Position', [100, 100, 1200, 500]);

% Sous-graphique 1 : Trajectoire initiale
subplot(1,2,1);
plot(Y(:,1)/1e6, Y(:,2)/1e6, 'b-', 'LineWidth', 1.5); hold on;
plot(xL/1e6, yL/1e6, 'k--', 'LineWidth', 1);
plot(0, 0, 'bo', 'MarkerSize', 15, 'MarkerFaceColor', 'b');
plot(xL(end)/1e6, yL(end)/1e6, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
plot(Y(1,1)/1e6, Y(1,2)/1e6, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
grid on; axis equal;
xlabel('x (10^6 m)'); ylabel('y (10^6 m)');
title(sprintf('Trajectoire initiale (Δv = %.0f m/s, θ = %.2f rad)', ...
              Delta_v0, theta0));
legend('Satellite', 'Orbite Lune', 'Terre', 'Lune finale', 'Départ', ...
       'Location', 'best');

% Sous-graphique 2 : Trajectoire optimale
subplot(1,2,2);
xL_opt = R * cos(omega * t_opt);
yL_opt = R * sin(omega * t_opt);
plot(Y_opt(:,1)/1e6, Y_opt(:,2)/1e6, 'r-', 'LineWidth', 1.5); hold on;
plot(xL_opt/1e6, yL_opt/1e6, 'k--', 'LineWidth', 1);
plot(0, 0, 'bo', 'MarkerSize', 15, 'MarkerFaceColor', 'b');
plot(xL_opt(end)/1e6, yL_opt(end)/1e6, 'ko', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'k');
plot(Y_opt(1,1)/1e6, Y_opt(1,2)/1e6, 'go', 'MarkerSize', 8, ...
     'MarkerFaceColor', 'g');
grid on; axis equal;
xlabel('x (10^6 m)'); ylabel('y (10^6 m)');
title(sprintf('Trajectoire optimale (Δv = %.0f m/s, θ = %.2f rad)', ...
              Delta_v_opt, theta_opt));
legend('Satellite', 'Orbite Lune', 'Terre', 'Lune finale', 'Départ', ...
       'Location', 'best');

fprintf('Programme terminé avec succès!\n');

% =========================================================================
% FONCTIONS AUXILIAIRES
% =========================================================================

function dY = trajectoire_derivee(t, Y, GMT, GML, R, omega)
    % Calcule la dérivée du vecteur d'état pour le système Terre-Lune
    
    x = Y(1);
    y = Y(2);
    vx = Y(3);
    vy = Y(4);
    
    % Position de la Lune
    xL = R * cos(omega * t);
    yL = R * sin(omega * t);
    
    % Distance au centre de la Terre
    r_terre = sqrt(x^2 + y^2);
    
    % Distance au centre de la Lune
    dx_lune = x - xL;
    dy_lune = y - yL;
    r_lune = sqrt(dx_lune^2 + dy_lune^2);
    
    % Accélérations gravitationnelles
    ax = (-GMT * x / r_terre^3) - (GML * dx_lune / r_lune^3);
    ay = (-GMT * y / r_terre^3) - (GML * dy_lune / r_lune^3);
    
    % Retour de la dérivée [vx, vy, ax, ay]
    dY = [vx; vy; ax; ay];
end

function [t, Y] = RK4(f, t0, tf, Y0, h)
    % Méthode de Runge-Kutta d'ordre 4
    
    t = (t0:h:tf)';
    n = length(t);
    m = length(Y0);
    Y = zeros(n, m);
    Y(1,:) = Y0';
    
    for i = 1:n-1
        k1 = f(t(i), Y(i,:)');
        k2 = f(t(i) + h/2, Y(i,:)' + h*k1/2);
        k3 = f(t(i) + h/2, Y(i,:)' + h*k2/2);
        k4 = f(t(i) + h, Y(i,:)' + h*k3);
        
        Y(i+1,:) = Y(i,:) + h/6 * (k1 + 2*k2 + 2*k3 + k4)';
    end
end

function d_min = calculer_distance_min_lune(dv, theta, r0, v0, GMT, GML, R, omega, T, h)
    % Calcule la distance minimale à la Lune pour des paramètres donnés
    
    % Position initiale
    x0 = r0 * cos(theta);
    y0 = r0 * sin(theta);
    
    % Vitesse initiale
    vx0 = -(v0 + dv) * sin(theta);
    vy0 = (v0 + dv) * cos(theta);
    
    % Vecteur d'état initial
    Y0 = [x0; y0; vx0; vy0];
    
    % Fonction dérivée
    f = @(t, Y) trajectoire_derivee(t, Y, GMT, GML, R, omega);
    
    % Résolution RK-4
    [t, Y] = RK4(f, 0, T, Y0, h);
    
    % Position de la Lune
    xL = R * cos(omega * t);
    yL = R * sin(omega * t);
    
    % Calcul des distances
    distances = zeros(length(t), 1);
    for i = 1:length(t)
        pos_sat = [Y(i,1), Y(i,2)];
        pos_lune = [xL(i), yL(i)];
        distances(i) = norm(pos_sat - pos_lune);
    end
    
    d_min = min(distances);
end

function [x_opt, f_opt] = section_doree(f, a, b, tol, max_iter)
    % Méthode de la section dorée pour minimiser une fonction
    
    phi = (1 + sqrt(5)) / 2;  % Nombre d'or
    resphi = 2 - phi;
    
    % Initialisation
    x1 = a + resphi * (b - a);
    x2 = b - resphi * (b - a);
    f1 = f(x1);
    f2 = f(x2);
    
    for iter = 1:max_iter
        if f1 < f2
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = a + resphi * (b - a);
            f1 = f(x1);
        else
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = b - resphi * (b - a);
            f2 = f(x2);
        end
        
        if abs(b - a) < tol
            break;
        end
    end
    
    if f1 < f2
        x_opt = x1;
        f_opt = f1;
    else
        x_opt = x2;
        f_opt = f2;
    end
end