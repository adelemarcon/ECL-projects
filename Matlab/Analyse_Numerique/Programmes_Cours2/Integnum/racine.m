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


