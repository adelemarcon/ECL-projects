%% Monte-Carlo
x=a+(b-a)*rand(N+1,1);
Imc=(b-a)/N*sum(f(x));

%% Racine

clear
close all

% Definition de la fonction et de l'integrale exacte
f=inline('sqrt(x)');
If=2/3;
% Boucle en N
liste_Err=[];
liste_N=100:200;
for N=liste_N
    x=(1:N-1)/N;
    IN=1/N*sum(f(x));
    liste_Err=[liste_Err,abs(If-IN)];
end
% Trace de l'erreur
plot(log10(liste_N),log10(liste_Err),'*')
grid on
size=20;
xlabel('$$\log_{10} N$$','Interpreter','latex','FontSize',size)
ylabel('$$\log_{10} |I-I_N|$$','Interpreter','latex','FontSize',size)
title('$$f:x\mapsto\sqrt{x}$$','Interpreter','latex','FontSize',size)
a=polyfit(log(liste_N),log(liste_Err),1);
text(2.2,-2.45,['pente=',num2str(a(1))],'Interpreter','latex','FontSize',size)


%% Rectangles

% Rectangles a gauche
x=a+(b-a)*(0:N-1)/N;
Irect=(b-a)/N*sum(f(x));

%% Regulière

clear
close all

% Definition de la fonction et de l'integrale exacte
f=inline('exp(x)');
If=exp(1)-1;
% Boucle en N
liste_Err=[];
liste_N=100:200;
for N=liste_N
    x=(0:N-1)/N;
    IN=1/N*sum(f(x));
    liste_Err=[liste_Err,abs(If-IN)];
end
% Trace de l'erreur
hold on
plot(log10(liste_N),log10(liste_Err),'*')
grid on
size=20;
xlabel('$$\log_{10} N$$','Interpreter','latex','FontSize',size)
ylabel('$$\log_{10} |I-I_N|$$','Interpreter','latex','FontSize',size)
title('$$f:x\mapsto e^x$$','Interpreter','latex','FontSize',size)
a=polyfit(log(liste_N),log(liste_Err),1);
text(2.2,-1.9,['pente=',num2str(a(1))],'Interpreter','latex','FontSize',size)


%% Sinus

clear
close all


% Definition de la fonction et de l'integrale exacte
f= @(x) sin(pi*x);
If=2/pi;
% Boucle en N
liste_Err=[];
liste_N=100:200;
for N=liste_N
    x=(0:N-1)/N;
    IN=1/N*sum(f(x));
    liste_Err=[liste_Err,abs(If-IN)];
end
% Trace de l'erreur
plot(log10(liste_N),log10(liste_Err),'*')
grid on
size=20;
xlabel('$$\log_{10} N$$','Interpreter','latex','FontSize',size)
ylabel('$$\log_{10} |I-I_N|$$','Interpreter','latex','FontSize',size)
title('$$f:x\mapsto\sin(\pi x)$$','Interpreter','latex','FontSize',size)
a=polyfit(log(liste_N),log(liste_Err),1);
text(2.2,-4.5,['pente=',num2str(a(1))],'Interpreter','latex','FontSize',size)

%% Sinus2

clear
close all


% Definition de la fonction et de l'integrale exacte
f=@(x) sin(2*pi*x);
If=0.;
% Boucle en N
liste_Err=[];
liste_N=100:200;
for N=liste_N
    x=(0:N-1)/N;
    IN=1/N*sum(f(x));
    liste_Err=[liste_Err,abs(If-IN)];
end
% Trace de l'erreur
plot(log10(liste_N),log10(liste_Err),'*')
grid on
size=20;
xlabel('$$\log_{10} N$$','Interpreter','latex','FontSize',size)
ylabel('$$\log_{10} |I-I_N|$$','Interpreter','latex','FontSize',size)
title('$$f:x\mapsto\sin(2\pi x)$$','Interpreter','latex','FontSize',size)

%% Unsurracine

clear
close all

% Definition de la fonction et de l'integrale exacte
f=inline('1./sqrt(1-x)');
If=2;
% Boucle en N
liste_Err=[];
liste_N=100:200;
for N=liste_N
    x=(1:N-1)/N;
    IN=1/N*sum(f(x));
    liste_Err=[liste_Err,abs(If-IN)];
end
% Trace de l'erreur
plot(log10(liste_N),log10(liste_Err),'*')
grid on
size=20;
xlabel('$$\log_{10} N$$','Interpreter','latex','FontSize',size)
ylabel('$$\log_{10} |I-I_N|$$','Interpreter','latex','FontSize',size)
title('$$f:x\mapsto\frac1{\sqrt{1-x}}$$','Interpreter','latex','FontSize',size)
a=polyfit(log(liste_N),log(liste_Err),1);
text(2.2,-0.9,['pente=',num2str(a(1))],'Interpreter','latex','FontSize',size)