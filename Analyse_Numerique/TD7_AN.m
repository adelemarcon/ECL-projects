function A = matriceA(Nx,beta)
    A = (1+ beta)*eye(Nx) - beta*diag(ones(Nx -1,1) ,-1);
end
%%
close all
% Parametres
Nx = 1000;
Nt = 400;
T = 4;
c = 0.5;
% Pas
dx = 10/(Nx -1);
dt = T/Nt;
beta = c*dt/dx;
A = matriceA(Nx,beta);
x = linspace(-5,5,Nx)';
t = linspace(0,T,Nt)';
% Algorithme
U = exp(-x.^2);
U(1) = 0;
M = zeros(Nx,Nt);
M(:,1) = U;
for n = 1 : Nt
    U = A\U;
    M(:,n) = U;
    % Dessin dynamique
    plot(x,U)
    title(['t = ' num2str(n*dt)])
    axis([-5 5 0 1.1])
    pause(0.01);
end
% Integrale par les rectangle a gauche
I = sum(U(1: end -1))*dx;
I
figure
surf(x,t,M','edgecolor','none')