clear; close all;

% Parametres
N = 5000;
bruit = 0.02;
% Function a minimiser
x = linspace(-1,10,N);
figure(1);
plot(x,f(x)+bruit*rand(1,N),'LineWidth',2);
title('Dichotomie','Interpreter','latex')
xlabel('$x$','Interpreter','latex')
ylabel('$f(x)$','Interpreter','latex')
axis([-1 10 -1 1])
hold on


% Dichotomie
Niter = 20;
a = -1;
b = 10;

erreur1 = zeros(1,Niter);
for i = 1 : Niter
    m = (a+b)/2;
    [y,d] = f(m);


    
    plot([a b],[-1 -1],'+r','LineWidth',3)
    h = plot([a b],[-1 -1],'r','LineWidth',1.5);
    h2 = plot([m m],[-1 1],'--r','LineWidth',1);
    title(['Dichotomie, $n = ' num2str(i-1) ', f(m_n) = ' num2str(y) '$'],'Interpreter','latex','FontSize',20)
    eps = 0.2;
    h3 = plot([m-eps m+eps],[f(m)-d*eps f(m)+d*eps],'r','LineWidth',2);
    if i<10
        pause;
    else
        pause(0.1);
    end
    delete(h);
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
grid on
semilogy(0:Niter-1,0.5*11*2.^(-(0:Niter-1)),'--b','LineWidth',1.5);
title('Convergence','Interpreter','latex','FontSize',20)
xlabel('$n$','Interpreter','latex','FontSize',20)
ylabel('Erreur','Interpreter','latex','FontSize',20)
legend({'Erreur $|m_n|$','$\frac12(b_0-a_0)2^{-n}$'},'Interpreter','latex','FontSize',20)

