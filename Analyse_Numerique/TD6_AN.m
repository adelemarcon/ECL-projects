clear; close all;

n = 100;
p = 1/(n+1);
un = ones(n-1,1);
U = zeros(n+1,1);
A = ((2)*eye(n,n) -diag(un,1) -diag(un,-1))/(p^2);
F = ones(n,1);
c = @(x) x;
f = @(x) (x^2 + (pi^2)*x)*cos(pi*x) + 2*pi*sin(pi*x);
for i=1:n
    xi = i*p;
    A(i,i) = A(i,i) + c(xi);
    F(i,1) = f(xi);
end

F(1,1) = F(1,1) + 0;
F(n,1) = F(n,1) + -1/(p^2);

U = A\F;
U(n+1) = -1;

% Application numerique
N=100;
x=linspace(0,1,N+1);
I1=sum(x.*cos(x.*(pi)))/N
I2=sum(U')/N
I = -0.19765;

u = @(x) x.*cos(x.*(pi));

for i=1:N+1
    L(i) = u(x(i));
end
figure(1)
plot(x,L,'b*')
hold on;
plot(x,U)
hold off

lN=linspace(1,100,100);
Err1=zeros(1,N);
Err2=zeros(1,N);
% Boucle sur N
for N=10:100
    x = linspace(0,1,N+1);
    x = x(2:N+1);
    h = 1/N;
    % Calcul avec la fonction réponse
    I1 = h*sum(u(x));
    Err1(N)=abs(I1-I);
    % Calcul avec méthode des différences finies
    I2 = h*sum(U');
    Err2(N)=abs(I2-I);
    % Test
end
% Graphes
figure(2)
plot(log10(lN),log10(Err1))
hold on
plot(log10(lN),log10(Err2))
grid on
xlabel('log_ {10}( N)')
ylabel('log_ {10}( Erreur )')

%% Exercice 4
clear all; close all; clc;

figure(1)
Alpha = [10,20,30,40,50];
for a=1:length(Alpha)
    alpha = Alpha(a);
    N = 100;
    h = 1/(N+1);
    X = zeros(N,1);
    un = ones(N-1,1);
    A = ((2)*eye(N,N) -diag(un,1) -diag(un,-1))/(h^2);
    for i=1:N
        X(i) = i*h;
    end
    
    f = @(x) (pi^2)*x.*sin(pi*x) -2*pi*cos(pi*x) +alpha*(x.*sin(pi*x)).^3;
    u = @(x) x.*sin(pi*x);
    F = zeros(N,1);
    Ur = zeros(N,1);
    for i=1:N
        F(i) = f(X(i));
        Ur(i) = u(X(i));
    end
    
    U = zeros(N,1);
    U = A\F;
    
    for j=2:N
        U_cube = U.^3;
        U = A\(F-alpha.*(U_cube));
    end
    
    clc
    plot(X,U)
    hold on
    plot(X,Ur)
    hold off
    legend('Courbe approximée','Courbe réelle')
    pause(1.5)
end