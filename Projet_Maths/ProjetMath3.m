n = 10;
T = 5;
phit = @(x) 1./( 1+ exp(-x(1:length(x))));
dphi = @(x) exp(-x) / (1 + exp(-x) )^2;
B = ones(n,1) + (1:n)'/(n-1);
W0 = eye(n,n);
Wstar = zeros(n,n);

% NOUVELLE DÉFINITION DE XI (utilisée dès le début)
R = (9 - 80/n)*ones(n,1) - floor( (1:n)'-(n/2)*ones(n,1) )/n;
C = -2*eye(n,n) + diag(ones(n-1,1),1) + diag(ones(n-1,1),-1);

% On doit calculer y de manière itérative car xi dépend de y
h = 0.01;
Npas = T/h;
tspan = (0:Npas)*h;
y = zeros(n,Npas+1);
y(:,1) = 0.25* (ones(n,1) - 0.5* (1:n)'/ (n-1) );

% Résolution de l'EDO avec la nouvelle xi
for j=1:Npas
    xi_val = C*y(:,j) + R - 0.5*sum(y(:,j))*ones(n,1);
    y(:,j+1) = y(:,j) + h*xi_val;
end

% Calcul des dérivées partielles de H par rapport à w_ij à W donnée
function [I] = dH(i,j,W,y,B,dphi,phit,C,R)
    N = size(y,2);
    h = 0.01;
    I = 0;
    for k=1:N
        y_k = y(:,k);
        xi_k = C*y_k + R - 0.5*sum(y_k)*ones(length(y_k),1);
        W_y_B = W*y_k + B;
        phi_W_y_B = phit(W_y_B);
        residual = phi_W_y_B - y_k - xi_k;
        dphi_val = dphi(W_y_B(i));
        I = I + h * 2 * y_k(j) * dphi_val * sum(residual);
    end
end

% Fonction objectif H
function [I] = H(W,y,B,phit,C,R)
    N = size(y,2);
    h = 0.01;
    I = 0;
    for k=1:N
        y_k = y(:,k);
        xi_k = C*y_k + R - 0.5*sum(y_k)*ones(length(y_k),1);
        residual = phit(W*y_k + B) - y_k - xi_k;
        I = I + h * norm(residual, 2)^2;
    end
end

% Test initial
res_initial = H(W0,y,B,phit,C,R);
fprintf('H initial (W0): %.6f\n', res_initial);

% Descente de gradient
Niter = 200;  % Augmenté pour meilleure convergence
U = W0;
pas = 0.001;  % Pas réduit pour plus de stabilité

for iter=1:Niter
    for i=1:n
        for j=1:n
            U(i,j) = U(i,j) - pas*dH(i,j,U,y,B,dphi,phit,C,R);
        end
    end
    if mod(iter,20)==0
        fprintf('Iteration %d, H = %.6f\n', iter, H(U,y,B,phit,C,R));
    end
end

res_final = H(U,y,B,phit,C,R);
fprintf('H final (U): %.6f\n', res_final);

% Simulation avec U appris
s = zeros(n,Npas+1);
s(:,1) = 0.25* (ones(n,1) - 0.5* (1:n)'/ (n-1) );

for k=1:Npas
    s(:,k+1) = s(:,k) + h * (U*s(:,k) + B);
end

% Visualisation
figure;
plot(tspan, y(1,:), 'g', 'LineWidth', 2);
hold on;
plot(tspan, s(1,:), 'r--', 'LineWidth', 2);
hold off;
legend('y (vraie dynamique)', 's (approximation)', 'Location', 'best', 'FontSize', 11);
xlabel('Temps');
ylabel('Composante 1');
title('Comparaison de la trajectoire');
grid on;

% Évaluation qualitative
eval_quali = norm(y-s, 'fro')/sqrt(n*(Npas+1));
fprintf('\nErreur moyenne (Frobenius normalisée): %.6f\n', eval_quali);

% Affichage de toutes les composantes
figure;
for k=1:n
    subplot(2,5,k);
    plot(tspan, y(k,:), 'g', 'LineWidth', 1.5);
    hold on;
    plot(tspan, s(k,:), 'r--', 'LineWidth', 1.5);
    hold off;
    title(sprintf('Composante %d', k));
    grid on;
    if k==1
        legend('y', 's', 'Location', 'best');
    end
end