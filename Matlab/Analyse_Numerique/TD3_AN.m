%% Exercice 1 - Optimisation numérique
clear; clc; close all;

f = @(v) 2*v(1)^2 + v(2)^2 + v(3)^2 + v(1)*(v(2)+v(3)) + sin(v(1));

grad_f = @(v) [4*v(1) + v(2) + v(3) + cos(v(1));
               2*v(2) + v(1);
               2*v(3) + v(1)];

hess_f = @(v) [4 - sin(v(1)), 1, 1;
               1, 2, 0;
               1, 0, 2];

fprintf('=== Question 1: Alpha-convexité ===\n');
% Test de la hessienne en plusieurs points
test_points = [0,0,0; 1,1,1; -1,-1,-1; pi/2,0,0];
min_eigenvalue = inf;

for i = 1:size(test_points,1)
    H = hess_f(test_points(i,:)');
    eigenvals = eig(H);
    min_eig = min(eigenvals);
    min_eigenvalue = min(min_eigenvalue, min_eig);
    fprintf('Point (%g,%g,%g): plus petite valeur propre = %.4f\n', ...
            test_points(i,1), test_points(i,2), test_points(i,3), min_eig);
end

fprintf('\nAlpha approximatif (plus petite valeur propre) = %.4f\n', min_eigenvalue);
fprintf('La fonction est donc alpha-convexe avec alpha ≈ %.2f\n\n', min_eigenvalue);

fprintf('=== Question 2: Gradient à pas fixe ===\n');

% Point initial
x0 = [1; 1; 1];
max_iter = 100;

% Différentes valeurs du pas
pas_values = [0.05, 0.1, 0.15, 0.2];
colors = ['b', 'r', 'g', 'm'];

figure('Name', 'Gradient à pas fixe');

for idx = 1:length(pas_values)
    rho = pas_values(idx);
    x = x0;
    history = zeros(max_iter+1, 1);
    history(1) = f(x);
    
    fprintf('\n--- Pas rho = %.2f ---\n', rho);
    
    for k = 1:max_iter
        grad = grad_f(x);
        x = x - rho * grad;
        history(k+1) = f(x);
        
        % Afficher les 10 premières itérations
        if k <= 10
            fprintf('Itération %2d: f = %.6f, ||grad|| = %.6f\n', ...
                    k, history(k+1), norm(grad));
        end
    end
    
    fprintf('Itération finale %d: f = %.6f\n', max_iter, history(end));
    fprintf('Point final: x = %.6f, y = %.6f, z = %.6f\n', x(1), x(2), x(3));
    
    % Tracé
    subplot(2,1,1);
    semilogy(0:max_iter, history, colors(idx), 'LineWidth', 1.5, ...
             'DisplayName', sprintf('\\rho = %.2f', rho));
    hold on;
    
    subplot(2,1,2);
    plot(0:max_iter, history, colors(idx), 'LineWidth', 1.5, ...
         'DisplayName', sprintf('\\rho = %.2f', rho));
    hold on;
end

subplot(2,1,1);
xlabel('Itération');
ylabel('f(x_k) (échelle log)');
title('Convergence du gradient à pas fixe (échelle log)');
legend('Location', 'best');
grid on;

subplot(2,1,2);
xlabel('Itération');
ylabel('f(x_k)');
title('Convergence du gradient à pas fixe');
legend('Location', 'best');
grid on;

%% Question 3: Méthode de Newton
fprintf('\n\n=== Question 3: Méthode de Newton ===\n');

x = x0;
max_iter_newton = 10;
history_newton = zeros(max_iter_newton+1, 1);
history_newton(1) = f(x);

fprintf('\nPoint initial: x = %.6f, y = %.6f, z = %.6f\n', x(1), x(2), x(3));
fprintf('f(x0) = %.6f\n\n', history_newton(1));

for k = 1:max_iter_newton
    grad = grad_f(x);
    H = hess_f(x);
    
    % Direction de Newton
    d = -H \ grad;
    x = x + d;
    
    history_newton(k+1) = f(x);
    
    fprintf('Itération %d:\n', k);
    fprintf('  x = %.6f, y = %.6f, z = %.6f\n', x(1), x(2), x(3));
    fprintf('  f(x) = %.6f\n', history_newton(k+1));
    fprintf('  ||gradient|| = %.8f\n\n', norm(grad));
    
    % Critère d'arrêt
    if norm(grad) < 1e-8
        fprintf('Convergence atteinte!\n');
        break;
    end
end

fprintf('Après 5 itérations: f(x_5) = %.6f\n', history_newton(6));
fprintf('Minimum estimé à %.6f (proche de -0.160984)\n', history_newton(end));

%% Comparaison des méthodes
figure('Name', 'Comparaison Gradient vs Newton');

% Pour une comparaison équitable, refaire gradient avec le meilleur pas
rho_best = 0.1;
x = x0;
history_grad_best = zeros(max_iter_newton+1, 1);
history_grad_best(1) = f(x);

for k = 1:max_iter_newton
    grad = grad_f(x);
    x = x - rho_best * grad;
    history_grad_best(k+1) = f(x);
end

subplot(2,1,1);
semilogy(0:max_iter_newton, abs(history_grad_best - history_newton(end)), ...
         'b-o', 'LineWidth', 2, 'DisplayName', 'Gradient (\\rho=0.1)');
hold on;
semilogy(0:max_iter_newton, abs(history_newton - history_newton(end)), ...
         'r-s', 'LineWidth', 2, 'DisplayName', 'Newton');
xlabel('Itération');
ylabel('|f(x_k) - f*| (échelle log)');
title('Erreur par rapport au minimum');
legend('Location', 'best');
grid on;

subplot(2,1,2);
plot(0:max_iter_newton, history_grad_best, 'b-o', 'LineWidth', 2, ...
     'DisplayName', 'Gradient (\\rho=0.1)');
hold on;
plot(0:max_iter_newton, history_newton, 'r-s', 'LineWidth', 2, ...
     'DisplayName', 'Newton');
xlabel('Itération');
ylabel('f(x_k)');
title('Valeur de la fonction');
legend('Location', 'best');
grid on;

fprintf('\n=== Analyse de la vitesse de convergence ===\n');
fprintf('Gradient: converge linéairement\n');
fprintf('Newton: converge quadratiquement (très rapide près du minimum)\n');


%%
function [val ,grad] = energie(u)
N = length(u)/2;
y = u(N+1:2*N);
val = sum(y)/(N+1);
grad = [zeros(N,1) ; ones(N,1)/(N+1)];
end

clear; close all;
% Parmetres
N = 20;
eps = 0.01;
Nitermax = 500;
rho = eps/3;
u = rand(2*N,1);
% Iterations
for i = 1 : Nitermax
    [vale ,grade] = energie(u);
    [valp ,gradp] = penalisation(u);
    obj = vale+1/eps*valp;

    g = grade + 1/eps*gradp;

    u = u - rho*g;

% Affichage dynamique
x = [0 ; u(1:N) ; 1];
y = [1 ; u(N+1:2*N) ; 3/2];
plot(x,y, '-o ');
title([ 'i = ' num2str(i)])
pause(0.01);
disp(obj)

end

function [x,y,Niter] = cable(N,eps)
Nitermax = 100000;

u = rand(2*N,1);
rho = eps/3;
for i = 1 : Nitermax
[~,grade] = energie(u);
[~,gradp] = penalisation(u);
g = grade+1/eps*gradp;

u = u - rho*g;

if max(abs(g)) < 1e-3
break
end
end

Niter = i;
x = [0 ; u(1:N) ; 1];
y = [1 ; u(N+1:2*N) ; 3/2];