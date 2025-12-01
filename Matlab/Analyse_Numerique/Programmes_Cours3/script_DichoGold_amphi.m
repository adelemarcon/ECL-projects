clear; close all;

% Parametres
N = 500;
bruit = 0;
% Function a minimiser
x = linspace(-1,10,N);
figure(1);
plot(x,f(x)+bruit*rand(1,N),'LineWidth',2);
title('Dichotomie','Interpreter','latex','FontSize',20)
xlabel('$x$','Interpreter','latex','FontSize',20)
ylabel('$f(x)$','Interpreter','latex','FontSize',20)
axis([-1 10 -1 1])
hold on


%% Dichotomie
Niter = 20;
a = -1;
b = 10;

erreur1 = zeros(1,Niter);
for i = 1 : Niter
    m = (a+b)/2;
    [y,d] = f(m);
    plot([a b],[-1 -1],'+r','LineWidth',3)
    h1 = plot([a b],[-1 -1],'r','LineWidth',1.5);
    h2 = plot([m m],[-1 1],'--r','LineWidth',1);
    title(['Dichotomie (n = ' num2str(i-1) ')'],'Interpreter','latex','FontSize',20)
    eps = 0.2;
    h3 = plot([m-eps m+eps],[f(m)-d*eps f(m)+d*eps],'r','LineWidth',2);

    delete(h1);
    delete(h2);
    delete(h3);
    if d<= 0
        a = m;
    else
        b = m;
    end
    erreur1(i) = abs(m);
end

figure(2);
semilogy(0:Niter-1,erreur1,'b','LineWidth',2);
hold on
semilogy(0:Niter-1,0.5*11*2.^(-(0:Niter-1)),'--b','LineWidth',1.5);
title('Convergence','Interpreter','latex','FontSize',20)
xlabel('$n$','Interpreter','latex','FontSize',20)
ylabel('Erreur','Interpreter','latex','FontSize',20)
legend({'Erreur $|m_n|$','$\frac12(b_0-a_0)2^{-n}$'},'Interpreter','latex','FontSize',20)



%% Nombre d'or
disp('Press enter')
pause;
figure(3);
plot(x,f(x),'LineWidth',2);
title('Methode du nombre d''or','Interpreter','latex','FontSize',20)
xlabel('$x$','Interpreter','latex','FontSize',20)
ylabel('$f(x)$','Interpreter','latex','FontSize',20)
axis([-1 10 -1 1])
hold on


% Initialisation    
gamma = (1+sqrt(5))/2; % Nb d'or
Niter = 20;
a = -1;

% Intevralle intial
b = 10;
c = b - (gamma-1)*(b-a);
d = a+(gamma-1)*(b-a);

erreur2 = zeros(1,Niter);

for i = 1 : Niter

    % Sortie Graphique
    plot([a c d b],[-1 -1 -1 -1],'+g','LineWidth',3)
    h1 = plot([a c d b],[-1 -1 -1 -1],'g','LineWidth',1.5);
    h2 = plot([c c ; d d]',[-1 1 ; -1 1]','--g','LineWidth',1);
    h3 = plot([c d],[f(c) f(d)]','go-','LineWidth',3);
    title(['Methode du nombre d''or (n = ' num2str(i-1) ')'],'Interpreter','latex','FontSize',20)
    
    % Pauses
    if i<10
        pause;
    else
        pause(0.1);
     end

    delete(h1);
    delete(h2);
    delete(h3);

    
    % Algo du nombre d'or
    if f(c)<= f(d)
        b = d;
        d = c;
        c = b - (gamma-1)*(b-a);
    else
        a = c;
        c = d;
        d =  a+(gamma-1)*(b-a);
    end

    m = (a+b)/2; % Point milieu 
    erreur2(i) = abs(m);
end

figure(4);
semilogy(0:Niter-1,erreur1,'LineWidth',1.8);
hold on
grid on
semilogy(0:Niter-1,0.5*11*2.^(-(0:Niter-1)),'--b','LineWidth',1.2);
semilogy(0:Niter-1,erreur2,'r','LineWidth',1.8);
semilogy(0:Niter-1,0.5*11*gamma.^(-(0:Niter-1)),'--r','LineWidth',1.2);
grid on

title('Convergence','Interpreter','latex','FontSize',20)
xlabel('$n$','Interpreter','latex','FontSize',20)
ylabel('Erreur','Interpreter','latex','FontSize',20)
legend({'Erreur dicho','$\frac12(b_0-a_0)2^{-n}$','Erreur nb d''or','$\frac12(b_0-a_0)\gamma^{-n}$'},'Interpreter','latex','FontSize',15)


