function [y,d] = f(x)
y = exp(-2*x) - 2*exp(-x);
d = -2*exp(-2*x) + 2*exp(-x);
end

%% GradPen


clear; close all;

t = [0.5 2 0.5
     0 0 1.5];
 
 
 eps = 2;
 
 [x,y] = meshgrid(linspace(-3,3,100),linspace(-3,3,100));
 
 
 h1 = fill(t(1,:),t(2,:),[0.8 0.8 1],'LineWidth',1);
 title('Gradient vs Gradient penalis\''e','Interpreter','latex','FontSize',15)
 hold on
 [~,h2] = contour(x,y,x.^2+y.^2,100,'k','LineWidth',0.1);
 plot([-1 3],[0 0],'k--')
 plot([0 0],[-1 1.7],'k--')
 axis([-0.2 2.2 -0.2 1.7])
 %axis equal
 
 Niter = 50;
 x0 = [0.7;1.2];
 h3 = plot(x0(1),x0(2),'r+','LineWidth',2);
 
 
 
 
 x = x0;
 p = 0.05;
 for i = 1 : Niter
     if i<6
        pause; 
     else
        pause(0.1);  
     end
     x = x - 2*p*x;
     plot(x(1),x(2),'r+','LineWidth',2)
     
 end
 h4 = legend([h1 h2 h3],{'$K$','$f(x_1,x_2)$','Gradient'},'Interpreter','latex','FontSize',15);
 disp('press Enter')
 pause;
 
 x = x0;
 h5 = plot(x0(1),x0(2),'o','LineWidth',3,'MarkerEdgeColor',[0 0.5 0]);
 delete(h4)
 for i = 1 : Niter
     if i<6
        pause; 
     else
        pause(0.1);  
     end
     x = x - 2*p*x - 1/eps*[(2*x(1) - 1)*(x(1)<0.5) ; 0];
     pause(0.1);
     plot(x(1),x(2),'go','LineWidth',3,'MarkerEdgeColor',[0 0.5 0])
      
 end
 
 h4 = legend([h1 h2 h3 h5],{'$K$','$f(x_1,x_2)$','Gradient','Gradient penalis\''e'},'Interpreter','latex','FontSize',15);

 %% GradProj

 clear; close all;

t = [0.5 2 0.5
     0 0 1.5];
 
 [x,y] = meshgrid(linspace(-3,3,100),linspace(-3,3,100));
 
 
 h1 = fill(t(1,:),t(2,:),[0.8 0.8 1],'LineWidth',1);
 title('Gradient vs Gradient projete','Interpreter','latex','FontSize',15)
 hold on
 [~,h2] = contour(x,y,x.^2+y.^2,100,'k','LineWidth',0.1);
 plot([-1 3],[0 0],'k--')
 plot([0 0],[-1 1.7],'k--')
 axis([-0.2 2.2 -0.2 1.7])
 %axis equal
 
 Niter = 20;
 x0 = [1.7;1];
 h3 = plot(x0(1),x0(2),'r+','LineWidth',2);
 
 
 
 
 x = x0;
 p = 0.1;
 for i = 1 : Niter
     if i<7
        pause; 
     else
        pause(0.1);  
     end
     x = x - 2*p*x;
     plot(x(1),x(2),'r+','LineWidth',2)
     
 end
 h4 = legend([h1 h2 h3],{'$K$','$f(x_1,x_2)$','Gradient'},'Interpreter','latex','FontSize',15);
 disp('press Enter')
 pause;
 
 x = x0;
 h5 = plot(x0(1),x0(2),'o','LineWidth',3,'MarkerEdgeColor',[0 0.5 0]);
 delete(h4)
 for i = 1 : Niter
     if i<7
        pause; 
     else
        pause(0.1);  
     end
     
     x = x - 2*p*x;
     
     plot(x(1),x(2),'.','LineWidth',3,'MarkerEdgeColor',[0 0.5 0])
     pause(0.1);
     x = [max(x(1),0.5);x(2)];
     if (x(1)+x(2)>2)
            x=[(1+(x(1)-x(2))/2),(1+(-x(1)+x(2))/2)];
     end
     plot(x(1),x(2),'go','LineWidth',3,'MarkerEdgeColor',[0 0.5 0])
      
 end
 
 h4 = legend([h1 h2 h3 h5],{'$K$','$f(x_1,x_2)$','Gradient','Gradient projete'},'Interpreter','latex','FontSize',15);

 %% Dicho

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

%% Dicho gold

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


%% Grad

clear; close all;

f = @(x,y) (sqrt(x.^2+y.^2)- 1).^2 +0.5*x+1;
grad = @(x,y) [2*(sqrt(x.^2+y.^2)- 1).*x./sqrt(x.^2+y.^2)+0.5 ; 2*(sqrt(x.^2+y.^2)- 1).*y./sqrt(x.^2+y.^2)];

N = 100;
p = 0.2;


[x,y] = meshgrid(linspace(-2,1.5,N),linspace(-1.3,1.3,N));
figure
title('Gradient a pas fixe p = 0.2')
%figure('position',[0 0 2000 1000])
subplot 121
s = surf(x,y,f(x,y));
s.EdgeColor = 'none';
shading('flat')
view([12 48])
light('position',[5 -3 10])

colormap jet
axis equal
xlabel('x')
ylabel('y')

subplot 122
contourf(x,y,f(x,y),40,'k')
axis equal
xlabel('x')
ylabel('y')

x = [0.1;-0.1];






for i = 1 : 80
    
    subplot 121
    hold on
    plot3(x(1),x(2),f(x(1),x(2))+0.05,'+r','LineWidth',3);
    
    subplot 122
    hold on
    plot(x(1),x(2),'+r','LineWidth',3);
    if i<6
        pause;
        disp('Press enter')
    else
        pause(0.05);
    end
    
    x = x - p*grad(x(1),x(2));
    
    
    
end

x = [1.4;1];

for i = 1 : 80w
    

    
     subplot 121
    hold on
    plot3(x(1),x(2),f(x(1),x(2))+0.05,'+g','LineWidth',3);
    
    subplot 122
    hold on
    plot(x(1),x(2),'+g','LineWidth',3);
    if i<5
        pause;
        disp('Press enter')
    else
        pause(0.051);
    end
    
    x = x - p*grad(x(1),x(2));
    
   
    
end

x = [1.4;0];

for i = 1 : 80
    
        subplot 121
    hold on
    plot3(x(1),x(2),f(x(1),x(2))+0.05,'+b','LineWidth',3);
    
    subplot 122
    hold on
    plot(x(1),x(2),'+b','LineWidth',3);
    if i<5
        pause;
        disp('Press enter')
    else
        pause(0.05);
    end
    
    
    x = x - p*grad(x(1),x(2));
    
    
    
end