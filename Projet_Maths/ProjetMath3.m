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

%%
n = 10;
T = 5;


phit = @(x) 1./( 1+ exp(-x(1:length(x))));
dphi = @(x) exp(-x) / ((1 + exp(-x) )^2);


B = ones(n,1) + (1:n)'/(n-1);
W0 = zeros(n,n);
Wstar = zeros(n,n);


% On a supposé lambda = 1
xi = @(s) -s+phit(Wstar*s+B);


% y est la solution de l'EDO y' = xi(y). On l'estime avec la méthode
% d'Euler explicite
h = 0.01;
Npas = T/h;
tspan = (0:Npas)*h;


y = zeros(n,Npas+1); % 1 ligne par composantes, 1 colonne par instant t = j*h
y(:,1) = 0.25* (ones(n,1) - 0.5* (1:n)'/ (n-1) ) ;


for j=1:Npas
   y(:,j+1) = y(:,j) + h*xi(y(:,j));
end


if(0)
   for k=1:length(y(:,1))
       plot(tspan,y(k,:));
       hold on
   end
   hold off
end

% calcul des dérivées partielles de H par rapport à w_ij à W donnée


function [I] = dH(i,j,W,y,B,dphi,phit,xi)
   N = length(y);
   h = 0.01;
   modele = @(i,j,u) 2*y(j,u)*dphi( W(i,:)*y(:,u) + B(i) )*sum( phit(W*y(:,u) +B) -y(:,u) - xi(y(:,u)) );
  
   I = 0;
   for k=1:N
       I = I + h*modele(i,j,k); % k correspond au rang de l'instant d'évaluation, qui vaut k*h
   end
end


res11 = dH(1,1,W0,y,B,dphi,phit,xi)
res12 = dH(1,1,Wstar,y,B,dphi,phit,xi)
res13 = dH(4,5,Wstar,y,B,dphi,phit,xi)
        2. Utilisation d'une descente de gradient sur la fonction H
Niter = 50;
U = W0; % pas possible de faire U de taille Niter*n*n car pb pour multiplier ensuite
function [I] = H(W,y,B,phit,xi)
   N = length(y);
   h = 0.01;
   modele = @(u) (norm( phit( W*y(:,u) + B ) -y(:,u) -xi(y(:,u))  , 2))^2;
  
   I = 0;
   for k=1:N
       I = I + h.*modele(k); % k correspond au rang de l'instant d'évaluation, qui vaut k*h
   end
end


res = H(Wstar,y,B,phit,xi);

pas = 1; % choix du pas à revoir


for k=1:Niter
   for i=1:n
       for j=1:n
           U(i,j) = U(i,j)-pas*dH(i,j,U,y,B,dphi,phit,xi);
       end
   end
end


res2 = U
h = 0.01;
Npas = T/h;
tspan = (0:Npas)*h;


s = zeros(n,Npas+1); % 1 ligne par composante, 1 colonne par instant t = j*h
s(:,1) = 0.25* (ones(n,1) - 0.5* (1:n)'/ (n-1) ) ;


for k=1:Npas
   s(:,k+1) = s(:,k) + h.* (U*s(:,k) + B);
end


if (1)
   plot(tspan,y(1,:),'g');
   hold on
   plot(tspan,s(1,:),'r');
   hold off
   legend('y','s', 'Location', 'best', 'FontSize', 11);
end
eval_quali = norm(y-s,2)
R = (9 - 80/n)*ones(n,1) - floor( (1:n)'-(n/2)*ones(n,1) )/n;


C = -2*eye(n,n) + diag(ones(n-1,1),1) + diag(ones(n-1,1),-1);
xi = @(s) C*s + R - 0.5*sum(s)*y;