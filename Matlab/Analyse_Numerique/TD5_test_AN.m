clear all; close all; clc;

% Définition de la fonction phi et sa dérivée
function [val, p] = phi(x)
    val = exp(-2*x) - (2*exp(-x))*(1+sin(3*x));
    p = -2*exp(-2*x) + 2*(exp(-x))*(1+sin(3*x)) - 2*(exp(-x))*3*cos(3*x);
end

% Fonction pour exécuter N itérations du gradient à pas fixe
function x_final = gradient_pas_fixe(x0, rho, N)
    x = x0;
    for k = 1:N
        [~, grad] = phi(x);
        x = x - rho * grad;
    end
    x_final = x;
end

% Paramètres
rho = 0.1;      % Pas fixe
x0 = 0.3;         % Point initial
N_max = 30;     % Nombre maximum d'itérations pour l'analyse

% === PARTIE 1: Exécution initiale avec N=20 ===
fprintf('=== EXÉCUTION AVEC N = 20 ITÉRATIONS ===\n\n');

x = zeros(21, 1);  % 0 à 20
x(1) = x0;
valeurs = zeros(21, 1);
gradients = zeros(21, 1);

[valeurs(1), gradients(1)] = phi(x(1));

fprintf('Itération\tx_k\t\tphi(x_k)\t\tphi''(x_k)\n');
fprintf('--------------------------------------------------------\n');
fprintf('%d\t\t%.6f\t%.6f\t%.6f\n', 0, x(1), valeurs(1), gradients(1));

for k = 1:20
    [~, grad] = phi(x(k));
    x(k+1) = x(k) - rho * grad;
    [valeurs(k+1), gradients(k+1)] = phi(x(k+1));
    fprintf('%d\t\t%.6f\t%.6f\t%.6f\n', k, x(k+1), valeurs(k+1), gradients(k+1));
end

% === PARTIE 2: Calcul de x_ref avec 1000 itérations ===
fprintf('\n=== CALCUL DU POINT DE RÉFÉRENCE ===\n');
N_ref = 1000;
x_ref = gradient_pas_fixe(x0, rho, N_ref);
fprintf('x_ref (après %d itérations) = %.10f\n', N_ref, x_ref);

% === PARTIE 3: Analyse de la vitesse de convergence ===
fprintf('\n=== ANALYSE DE LA VITESSE DE CONVERGENCE ===\n');
fprintf('Modèle: erreur(N) = C * alpha^N\n\n');

N_values = [10, 15, 20, 25, 30];
erreurs = zeros(size(N_values));

fprintf('N\tx_N\t\tErreur abs(x_N - x_ref)\n');
fprintf('--------------------------------------------------------\n');
for i = 1:length(N_values)
    N = N_values(i);
    x_N = gradient_pas_fixe(x0, rho, N);
    erreurs(i) = abs(x_N - x_ref);
    fprintf('%d\t%.10f\t%.6e\n', N, x_N, erreurs(i));
end

% Estimation de C et alpha avec polyfit
% erreur = C * alpha^N  =>  log(erreur) = log(C) + N*log(alpha)
% On pose y = log(erreur), x = N, alors y = a + b*x avec b = log(alpha), a = log(C)

log_erreurs = log(erreurs);
coeff = polyfit(N_values, log_erreurs, 1);  % Régression linéaire

b = coeff(1);  % pente = log(alpha)
a = coeff(2);  % ordonnée à l'origine = log(C)

alpha_estime = exp(b);
C_estime = exp(a);

fprintf('\n=== RÉSULTATS DE L''ESTIMATION ===\n');
fprintf('C estimé = %.6e\n', C_estime);
fprintf('alpha estimé = %.6f\n', alpha_estime);
fprintf('\nModèle estimé: erreur(N) ≈ %.6e * (%.6f)^N\n', C_estime, alpha_estime);

% Vérification du modèle
fprintf('\n=== VÉRIFICATION DU MODÈLE ===\n');
fprintf('N\tErreur réelle\tErreur modèle\tÉcart relatif\n');
fprintf('--------------------------------------------------------\n');
for i = 1:length(N_values)
    N = N_values(i);
    erreur_reelle = erreurs(i);
    erreur_modele = C_estime * (alpha_estime^N);
    ecart_relatif = abs(erreur_reelle - erreur_modele) / erreur_reelle * 100;
    fprintf('%d\t%.6e\t%.6e\t%.2f%%\n', N, erreur_reelle, erreur_modele, ecart_relatif);
end

% === GRAPHIQUES ===
figure('Position', [100, 100, 1400, 500]);

% Graphique 1: Évolution de x_k (20 premières itérations)
subplot(1,3,1);
plot(0:20, x, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6);
hold on;
yline(x_ref, 'r--', 'LineWidth', 2);
grid on;
xlabel('Itération k');
ylabel('x_k');
title('Évolution de x_k (N=20)');
legend('x_k', 'x_{ref}', 'Location', 'best');

% Graphique 2: Erreur en échelle logarithmique
subplot(1,3,2);
semilogy(N_values, erreurs, 'bo', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'b');
hold on;
N_plot = linspace(10, 30, 100);
erreur_modele_plot = C_estime * (alpha_estime.^N_plot);
semilogy(N_plot, erreur_modele_plot, 'r-', 'LineWidth', 2);
grid on;
xlabel('Nombre d''itérations N');
ylabel('Erreur |x_N - x_{ref}|');
title('Convergence de l''algorithme');
legend('Erreur réelle', sprintf('Modèle: %.2e*(%.4f)^N', C_estime, alpha_estime), 'Location', 'best');

% Graphique 3: Régression linéaire sur log(erreur)
subplot(1,3,3);
plot(N_values, log_erreurs, 'bo', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'b');
hold on;
N_plot = linspace(10, 30, 100);
log_erreur_fit = a + b*N_plot;
plot(N_plot, log_erreur_fit, 'r-', 'LineWidth', 2);
grid on;
xlabel('Nombre d''itérations N');
ylabel('log(Erreur)');
title('Régression linéaire pour estimation');
legend('log(Erreur réelle)', sprintf('Fit: y = %.4f + %.4f*N', a, b), 'Location', 'best');

% Graphique supplémentaire: Trajectoire sur la fonction
figure('Position', [150, 150, 800, 600]);
x_plot = linspace(-1, 2, 1000);
phi_plot = zeros(size(x_plot));
for i = 1:length(x_plot)
    phi_plot(i) = phi(x_plot(i));
end
plot(x_plot, phi_plot, 'b-', 'LineWidth', 2);
hold on;
plot(x(1:21), valeurs(1:21), 'ro-', 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(x(1), valeurs(1), 'gs', 'MarkerSize', 15, 'LineWidth', 2);
plot(x(21), valeurs(21), 'mp', 'MarkerSize', 15, 'LineWidth', 2);
plot(x_ref, phi(x_ref), 'kd', 'MarkerSize', 12, 'LineWidth', 2, 'MarkerFaceColor', 'k');
grid on;
xlabel('x');
ylabel('\phi(x)');
title('Trajectoire de l''algorithme sur la fonction \phi(x)');
legend('\phi(x)', 'Itérations', 'Point initial (x_0)', 'Point à N=20', 'Point de référence (x_{ref})', 'Location', 'best');
hold off;

fprintf('\n=== INTERPRÉTATION ===\n');
if alpha_estime < 1
    fprintf('α < 1 : L''algorithme converge linéairement vers x_ref\n');
    fprintf('Taux de convergence : %.2f%% par itération\n', (1-alpha_estime)*100);
else
    fprintf('α ≥ 1 : L''algorithme ne converge pas\n');
end
