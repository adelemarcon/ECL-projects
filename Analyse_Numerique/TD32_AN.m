clear
close all

f = @(u) 2*u(1)^2 + u(2)^2 + u(3)^2 + u(1)*(u(2) + u(3)) + sin(u(1));
gradf = @(u) [4*u(1) + u(2) + u(3) + cos(u(1)) ; 2*u(2) + u(1) ; 2*u(3) + u(1)];
Hf = @(u) [4 - sin(u(1)) 1 1 ; 1 2 0 ; 1 0 2] ;
% Gradient a pas fixe
rho = 0.2;
N = 10000;
u = [1;1;1];
for n=1:N
    u = u - rho*gradf(u);
end
uex = u;
% Test de convergence pour la methode du gradient pour differents pas
Ntest = 50;
rho_list = [0.05 0.1 0.2 0.5];
N_rho = length(rho_list);
L = cell(N_rho ,1);
for k = 1 : N_rho
    rho = rho_list(k);
    e = zeros(1,Ntest);
    u = [1;1;1];
    for n = 1 : Ntest
        u = u - rho*gradf(u);
        e(n) = norm(u-uex)/norm(uex);
    end
    semilogy(1:Ntest ,e,'linewidth',1);
    grid on; hold on;
    L{k} = ['rho = ' num2str(rho)];
end
legend(L);
xlabel('N'); ylabel('Erreur relative')
% Methode de Newton
u = [1;1;1];
e = zeros(1,Ntest);
for n=1:5
    u = u - Hf(u)\gradf(u);
    e(n) = norm(u-uex)/norm(uex);
end
semilogy(1:Ntest ,e,'linewidth',1);
L = [L ; {'Newton'}];
legend(L);
% Solution
disp('Minimum')
disp('Point de minimum')
disp(u)