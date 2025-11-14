% Parametres
d=15;

% Initialisations
H=hilb(d);
x_exact=ones(d,1);
scmb=H*x_exact;

% Resolution
sol=H\scmb;
sol
norme_difference=norm(sol-x_exact)

