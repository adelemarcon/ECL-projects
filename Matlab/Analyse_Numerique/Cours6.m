clear
close all

% Parametres
Nx = 100;
Nt = 200;
c = -1;
T = 3;

x = linspace(-2,2,Nx)';
t = linspace(0,T,Nt+1)';

dx = 4/(Nx-1);
dt = T/Nt;
beta = c*dt/dx;
beta


U0 = exp(-x.^2);

U = U0;

% Matrice d'iteration
D = eye(Nx) - diag(ones(Nx-1,1),1);
A = eye(Nx) + beta*D;


% Algo
T = U;
for n = 1 : Nt
    U = A*U;
    plot(x,U)
    axis([-2 2 0 1])
    title(['t = '  num2str(n*dt,'%10.2f\n')])
    pause(0.01)
    T = [T U];
end

figure
surf(x,t,T','EdgeColor','none')
xlabel('x')
ylabel('t')
zlabel('u(x,t)')



