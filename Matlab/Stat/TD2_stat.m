m0=100;
m1=120;
sigma = 10;
n = 6;
alpha1 = 0.05;
alpha2 = 0.01;

d_alpha = norminv(1-alpha2)
c = m0 + sigma/sqrt(n)*d_alpha
d_alphap = (c-m1)/sigma*sqrt(n)
beta = normcdf(d_alphap)

%%

E = [5 7 9 10 6 8 6 5 9 4 13];
moy = mean(E);
variance = var(E)
alpha = 0.05;
n = 11;

D = (n-1)*variance/4

q1 = chi2inv(alpha/2,n-1);
q2 = chi2inv(1-alpha/2,n-1);

Interval = [4*q1/(n-1), 4*q2/(n-1)]

%%
clear all
close all
% Exercice 3
load('/home/adele/ECL-projects/Matlab/Stat/noix.txt');
Variable = noix;
edges = [30 34 36 38 40 42 44 46 50]
effectifs = histcounts(Variable,edges)
alpha = 0.00002

% Estimer les paramètres
mu_chapeau = mean(Variable)
s_chapeau = std(Variable)

% Histogramme et densité théorique
figure;
histogram(Variable, 'Normalization', 'pdf');
hold on;
x = linspace(min(Variable)-1, max(Variable)+1);
y = normpdf(x, mu_chapeau, s_chapeau);
plot(x, y, 'r-', 'LineWidth', 2);
legend('Données','Loi normale');
title('Ajustement à loi normale');

% Calculer les effectifs théoriques
n = 200;
for i = 2:length(edges)-1
    p(i) = normcdf(edges(i+1), mu_chapeau, s_chapeau) - normcdf(edges(i), mu_chapeau, s_chapeau);
    E(i) = n*p(i);
end

p(1) = normcdf(edges(2),mu_chapeau,s_chapeau);
p(8) = 1 - normcdf(edges(8),mu_chapeau,s_chapeau);
E(1) = n*p(1);
E(8) = n*p(8);


% Calculer D²
D2 = sum((effectifs - E).^2 ./ E)

% Valeur critique
k = length(effectifs)
ddl = k - 3;
chi2_critique = chi2inv(1-alpha, ddl)

% Conclusion
if D2 > chi2_critique
    disp('On rejette H₀');
else
    disp('On ne rejette pas H₀');
end