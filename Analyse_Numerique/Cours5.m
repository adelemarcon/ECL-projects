%% Erreur

close all
clear
%
lN=2.^(1:10);
err=[];

for N=lN

    h=1/(N+1);
    x=linspace(0,1,N+2);
    xx=x(2:N+1);
    
    % Construction de la matrice
    un=ones(N-1,1);
    A=(2*eye(N)-diag(un,1)-diag(un,-1))/h^2;
    F=10*sin(3*xx');
    F(1)=F(1)+1/h^2;
    F(N)=F(N)+2/h^2;
    
    % Resolution
    U=A\F;
    
    % Calcul de l'erreur
    uex=10/9*sin(3*xx')+(1-10/9*sin(3))*xx'+1;
    
    err=[err,norm(U-uex,'inf')];

end

plot(lN,err,'*-','LineWidth',2)
xlabel('N')
ylabel('Erreur uniforme')
set(gca,'FontSize',16)
figure
plot(log(lN),log(err),'*-','LineWidth',2)
xlabel('log(N)')
ylabel('log(Erreur uniforme)')
set(gca,'FontSize',16)
grid on

%% Lap1D

clear
close all

N=100;
h=1/(N+1);
x=linspace(0,1,N+2);
xx=x(2:N+1);

% Construction de la matrice
un=ones(N-1,1);
A=(2*eye(N)-diag(un,1)-diag(un,-1))/h^2;

F=10*sin(3*xx');
F(1)=F(1)+1/h^2;
F(N)=F(N)+2/h^2;

% Resolution
U=A\F;

% Trace
t=linspace(0,1,1000);
uex=10/9*sin(3*t)+(1-10/9*sin(3))*t+1;
plot(t,uex,'r--','LineWidth',2)
hold on
plot(x,[1;U;2])
legend('Solution exacte','Solution approchee')
set(gca,'FontSize',16)

%% Lap2D

clear;
close all;


N=50;
h=1/(N+1);
x=linspace(0,1,N+2);
xx=x(2:N+1);

% Construction de la matrice 2D
un=ones(N-1,1);
H=(4*eye(N)-diag(un,1)-diag(un,-1));
I = eye(N);

A = zeros(N^2,N^2);

for i = 1 : N
    A(1+(i-1)*N:i*N,1+(i-1)*N:i*N) = H;
    if i>1
        A(1+(i-1)*N:i*N,1+(i-2)*N:(i-1)*N) = -I; 
    end
     if i<N
        A(1+(i-1)*N:i*N,1+(i)*N:(i+1)*N) = -I; 
    end
end
A = A/h^2;
figure
imagesc(A)
title('Matrice A')
%%
F = ones(N^2,1);

U = A\F;
%%
u = reshape(U,N,N);


figure
contour(xx,xx,u,20)
colorbar
colormap jet
axis image
xlabel('$x$','interpreter','latex','fontsize',20)
ylabel('$y$','interpreter','latex','fontsize',20)
title('Solution de $-\Delta u(x,y) = 1$','interpreter','latex','fontsize',20)


figure
surf(xx,xx,u)
colormap jet
xlabel('$x$','interpreter','latex','fontsize',20)
ylabel('$y$','interpreter','latex','fontsize',20)
zlabel('$u(x,y)$','interpreter','latex','fontsize',20)
title('Solution de $-\Delta u(x,y) = 1$','interpreter','latex','fontsize',20)

%% Tir1

close all
clear
% Parametres
q=4.5;

k=1;
alpha=1;
beta=2;
N=100;
h=1/N;

% Methode d'Euler
Y=[alpha;q];
x=0;
lX=[0];lY=[alpha];
for i=1:N
    Y=Y+h*[Y(2);-1/k*10*sin(3*x)];
    x=x+h;
    lX=[lX,x];lY=[lY,Y(1)];
end

% Trace 
plot(lX,lY,'Linewidth',2)
xlabel('x')
ylabel('u(x)')
set(gca,'FontSize',16)

%% Tir2

close all
clear
% Parametres
lq=[-5:5];
lu1=[];

for q=lq

    k=1;
    alpha=1;
    beta=2;
    N=100;
    h=1/N;
    
    % Methode d'Euler
    Y=[alpha;q];
    x=0;
    for i=1:N
        Y=Y+h*[Y(2);-1/k*10*sin(3*x)];
        x=x+h;
    end
    
    lu1=[lu1,Y(1)];

end

plot(lq,lu1,'*-','LineWidth',2)
xlabel('q','FontSize',16)
ylabel('$u_q(1)$','Interpreter','latex','FontSize',20)

%% Tir3

close all
clear
% Parametres
k=1;
alpha=1;
beta=2;
N=100;
h=1/N;
    
% Tir avec q=0
    
    % Methode d'Euler
    Y=[alpha;0];
    x=0;
    for i=1:N
        Y=Y+h*[Y(2);-1/k*10*sin(3*x)];
        x=x+h;
    end
    
    val0=Y(1);
    
% Tir avec q=1
       
    % Methode d'Euler
    Y=[alpha;1];
    x=0;
    for i=1:N
        Y=Y+h*[Y(2);-1/k*10*sin(3*x)];
        x=x+h;
    end
    
    val1=Y(1); 

% Calcul de q_optimal

    q_opt=(beta-val0)/(val1-val0);
    % Methode d'Euler
    Y=[alpha;q_opt];
    x=0;
    lX=[0];lY=[alpha];
    for i=1:N
        Y=Y+h*[Y(2);-1/k*10*sin(3*x)];
        x=x+h;
        lX=[lX,x];lY=[lY,Y(1)];
    end

    % Trace 
    plot(lX,lY,'Linewidth',2)
    hold on
    t=linspace(0,1,1000);
    uex=10/9*sin(3*t)+(1-10/9*sin(3))*t+1;
    plot(t,uex,'r--','LineWidth',2)
    legend('Solution approchee','Solution exacte')
    xlabel('x')
    ylabel('u(x)')
    set(gca,'FontSize',16)
    
%% vp1D

clear;
close all;

N=200;
h=1/(N+1);
x=linspace(0,1,N+2);
xx=x(2:N+1);

% Construction de la matrice
un=ones(N-1,1);
A=(2*eye(N)-diag(un,1)-diag(un,-1));
A=A/h^2;

figure
imagesc(A)
colorbar

Nvp = 4;
[V,D] = eigs(A,Nvp,'sm');
d = diag(D);
d
figure
for i = 1 : Nvp
    plot(xx,V(:,i))
    hold on
end

%% vp2D

clear;
close all;


N=50;
h=1/(N+1);
x=linspace(0,1,N+2);
xx=x(2:N+1);

% Construction de la matrice -laplacien 2D
un=ones(N-1,1);
B=(4*eye(N)-diag(un,1)-diag(un,-1));
I = eye(N);

A = zeros(N^2,N^2);
for i = 1 : N
    A(1+(i-1)*N:i*N,1+(i-1)*N:i*N) = B;
    if i>1
        A(1+(i-1)*N:i*N,1+(i-2)*N:(i-1)*N) = -I; 
    end
     if i<N
        A(1+(i-1)*N:i*N,1+(i)*N:(i+1)*N) = -I; 
    end
end
A = A/h^2;
figure
subplot 121
spy(A)
axis image

subplot 122
imagesc(A)
axis image



%% Calcul des ?lements propres :
Nvp = 16;
sNvp = ceil(sqrt(Nvp));
[V,D] = eigs(A,Nvp,'sm');
d = diag(D);

% Plots

figure
for i = 1 : Nvp
    U = V(:,i);
    subplot(sNvp,sNvp,i)
    imagesc(reshape(U,N,N));
    title(['\lambda = ',num2str(d(i),'%10.3f\n')])
    axis image
    axis off
    
end



