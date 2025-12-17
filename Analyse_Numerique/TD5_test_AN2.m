clear all; close all; clc
% Fonction et intervale
f= @(x) 1./x;
a = 1;
b = 2;
Iex = log(2);
% Parametres
kmax = 4;
Ntest = 20;
% Intialisation
listeN = floor(logspace(0,3,Ntest));
TableErreurs = zeros(kmax ,Ntest);
% Boucles sur k
for k = 1:kmax % (k +1) est le nombre de points de la methode elementaire
    disp(' ');
    disp(['k = ',num2str(k)]);
    % Points de quadrature
    t = (0:k)/k;
    % Calcul des poids
    V = t.^((0:k)');
    rhs = 1./(1:k+1)';
    w = V\rhs;
    Erreurs= zeros(1,Ntest);
    % Boucle sur N
    for j = 1 : Ntest
        N = listeN(j);
        disp(['N = ',num2str(N)]);
        h = (b-a)/N;
        % Approximation de l'integrale
        I = 0;
        for i = 0:N-1
            q = 0:k;
            xiq = a + h*i + h*t(q+1);
            I = I + sum(w'.*f(xiq));
        end
        I=I*h;
        % Erreur relative
        Erreurs(j) = abs(I-Iex)/Iex;
    end
    TableErreurs(k,:) = Erreurs;
end

loglog(listeN ,TableErreurs ,'*-');
grid on;
legend(cellstr(num2str((1:9)', 'k = %-1.f')));
xlabel('N'); ylabel('Erreur');

clear all; close all; clc

% Question 2 : Approximation de l'intégrale de sqrt(x) sur [0,2]
% avec les poids calculés précédemment

% Fonction et intervalle
f = @(x) sqrt(x);
a = 0;
b = 2;

% Valeur exacte de l'intégrale
Iex = (2/3) * (b^(3/2) - a^(3/2));
fprintf('Valeur exacte de l''intégrale : %.10f\n\n', Iex);

% Nombre d'intervalles
N = 20;
h = (b - a) / N;

% k = 4 (5 points de quadrature)
k = 4;

% Points de quadrature
t = (0:k)/k;  % t = [0, 0.25, 0.5, 0.75, 1]

% Poids donnés (de votre image)
w = [0.0778; 0.3556; 0.1333; 0.3556; 0.0778];

fprintf('Méthode avec k = %d (%d points)\n', k, k+1);
fprintf('Points de quadrature : t = ');
fprintf('%.2f ', t);
fprintf('\n');
fprintf('Poids : w = ');
fprintf('%.4f ', w);
fprintf('\n\n');

% Approximation de l'intégrale avec la méthode composée
I = 0;
for i = 0:N-1
    q = 0:k;
    xiq = a + h*i + h*t(q+1);
    I = I + sum(w'.*f(xiq));
end
I = I * h;

% Calcul de l'erreur
Erreur_abs = abs(I - Iex);
Erreur_rel = Erreur_abs / Iex;

% Affichage des résultats
fprintf('Résultats avec N = %d intervalles :\n', N);
fprintf('Approximation I_N = %.10f\n', I);
fprintf('Valeur exacte I_ex = %.10f\n', Iex);
fprintf('Erreur absolue = %.2e\n', Erreur_abs);
fprintf('Erreur relative = %.2e\n', Erreur_rel);