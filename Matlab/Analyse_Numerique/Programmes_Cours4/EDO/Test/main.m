clear; close all;

% Param
T = 1;
u0 = 1;
N = 50;
h = T/N;
t = linspace(0,T,N+1);

Uex = exp(t.^2);

% Dynamique
f = @(t,u) 2*t*u;

% Methode d'Euler
U = zeros(1,N+1);
U(1) = u0;
for n = 1 : N
    U(n+1) = U(n) + h*f(t(n),U(n));
end

plot(t,U,t,Uex)
legend('Euler','Uex')












