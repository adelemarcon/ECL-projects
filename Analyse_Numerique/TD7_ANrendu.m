clear ; close all ;
% DOnnées
T = 1.4;
min = -10;
max = 150;
Nx = 500;
Nt = 1500;

% Fonctions
v= @(x,t) 100*(1 + (1 + tanh(x/20))*cos(4*pi*t)) ;
a= @(x,t) 5*(1 - tanh(x/20).^2)*cos(4*pi*t) ;
f= @(x,t) t* exp(-(4*t + abs(x/2).^2)) ;

% Temps, Espace
x = linspace(min,max,Nx);
t = linspace(0,T,Nt);
dx = (max-min)/(Nx-1);
dt = T/(Nt-1);

% Schéma Lax_Freidrichs
U = zeros(Nx,1);
for n = 1:Nt-1
    beta = v(x,t(n))*dt/dx;
    alpha = -dt*a(x,t(n));
    d1 = beta(2:Nx);
    A = 0.5*(diag(1+beta(2:Nx),-1) + diag(alpha) + diag(1-beta(1:Nx-1),1));
    F = 0.5*dt*f(x,t(n));
    U = A*U + F;
    plot (x,U,'LineWidth',1.5)
    axis ([min ,max , -2e-3 ,6e-3])
    grid on
end

%%
clear ; close all ;
% Parametres
xmin = -10;
xmax = 150;
Nx = 500;
T = 1.4;
Nt = floor (3* Nx ) ;

v= @(x,t) 100*(1 + (1 + tanh(x/20))*cos(4*pi*t)) ;
a= @(x,t) 5*(1 - tanh(x/20).^2)*cos(4*pi*t) ;
f= @(x,t) t* exp(-(4*t + abs(x/2).^2)) ;
% Discre tisati on en espace
x = linspace (xmin,xmax,Nx) ;
dx = (xmax-xmin) /(Nx-1) ;
% Discre tisati on en temps
t = linspace (0,T,Nt) ;
dt = T /(Nt-1) ;
% Schema de Lax_Freidrich
U = zeros (Nx ,1) ;
for n = 1 : Nt -1
% Creation des matrices
beta = v(x,t(n))*dt/dx ;
alpha = -dt*a(x,t(n));
d1 = beta(2:Nx);
A = 0.5*( diag (1+beta(2:Nx),-1) + diag(alpha) + diag(1-beta(1:Nx-1),1)) ;
F = 0.5* dt * f (x,t(n));
% Schema
U = A*U + F;
% Affichage graphique dynamique toute les 10 iterations
if ~ mod (n ,5)
plot (x,U,'LineWidth',1.5)
axis ([ xmin , xmax , -2e-3 ,6e-3])
grid on
end
end

%%
% Parametres
xmin = -10;
xmax = 150;
Nx = 500;
T = 1.4;
Nedo = 1000;
% Fonctions
v = @( x , t ) 100*(*(1 + (1 + tanh ( x /20) ) * cos (4* pi * t ) ) ;
a = @( x , t ) 5*(1 - tanh ( x /20) .^2) * cos (4* pi * t ) ;
f = @( x , t ) t * exp ( -(4* t + abs ( x /2) .^2) ) ;
mv = @( x , t ) -v (x ,T - t ) ;
% Discre tisati on en espace
x = linspace ( xmin , xmax , Nx ) ;
% Methode des c a r a c t e r i s i t q u e s en tout point x avecr RK4
h = T / Nedo ;
U = zeros ( Nx ,1) ;
for i = 1 : Nx
% Calcul de la fonction c ar ac t er is t iq u e ( EDO en remontant le temps
Y = RK4 ( mv , x ( i ) ,T , Nedo ) ;
X = fliplr ( Y ) ;
Xfun = @( t ) carac (X ,t , h ) ;
end
% Calcul de la solution le long de la ca r ac te r is t iq ue
g = @( phi , t ) f ( Xfun ( t ) ,t ) - a ( Xfun ( t ) ,t ) * phi ;
phi = RK4 (g ,0 ,T , Nedo ) ;
U ( i ) = phi ( end ) ;
figure
plot (x , U )
legend ( ' U avec les ca ra c te ri s iq ue s ' )
% Fonction qui evalue une car acteri sique en un temps quelconque
function Xt = carac (X ,t , h )
n = floor ( t / h ) ;
d = n - t/h;
Xt = (1 - d ) * X ( n +1) + d * X ( n +2) ;
end
function U = RK4 (f , U0 ,T , N )
t = linspace (0 ,T , N +1) ;
h = T/N;
n = length ( U0 ) ;
U = zeros (n , N +1) ;
U (: ,1) = U0 ;
for n = 1 : N
Un = U (: , n ) ;
k1 = f ( Un , t ( n ) ) ;
k2 = f ( Un + h /2* k1 , t ( n ) ) ;
k3 = f ( Un + h /2* k2 , t ( n ) ) ;
k4 = f ( Un + h * k3 , t ( n ) ) ;
U (: , n +1) = U (: , n ) + h /6*( k1 + 2* k2 + 2* k3 + k4 ) ;
end
end