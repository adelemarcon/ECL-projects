n = 10;
T = 5;


phit = @(x) 1./( 1+ exp(-x(1:length(x))));
dphi = @(x) exp(-x) / (1 + exp(-x) )^2;


B = ones(n,1) + (1:n)'/(n-1);
W0 = eye(n,n);
Wstar = zeros(n,n);


% On a supposé lambda = 1
xi = @(s) -s+phit(Wstar*s+B);


% y est la solution de l'EDO y' = xi(y). On l'estime avec la méthode
% d'Euler explicite
h = 0.01;
Npas = T/h;
tspan = (0:Npas)*h;


y = zeros(n,Npas+1); % 1 ligne par composantes, 1 colonne par instant t = j*h
y(:,1) = 0.25* (ones(n,1) - 0.5* (1:n)'/ (n-1) ) ;


for j=1:Npas
   y(:,j+1) = y(:,j) + h*xi(y(:,j));
end


if(0)
   for k=1:length(y(:,1))
       plot(tspan,y(k,:));
       hold on
   end
   hold off
end

% calcul des dérivées partielles de H par rapport à w_ij à W donnée


function [I] = dH(i,j,W,y,B,dphi,phit,xi)
   N = length(y);
   h = 0.01;
   modele = @(i,j,u) 2*y(j,u)*dphi( W(i,:)*y(:,u) + B(i) )*sum( phit(W*y(:,u) +B) -y(:,u) - xi(y(:,u)) );
  
   I = 0;
   for k=1:N
       I = I + h*modele(i,j,k); % k correspond au rang de l'instant d'évaluation, qui vaut k*h
   end
end


res11 = dH(1,1,W0,y,B,dphi,phit,xi)
res12 = dH(1,1,Wstar,y,B,dphi,phit,xi)
res13 = dH(4,5,Wstar,y,B,dphi,phit,xi)

Niter = 50;
U = W0; % pas possible de faire U de taille Niter*n*n car pb pour multiplier ensuite
function [I] = H(W,y,B,phit,xi)
   N = length(y);
   h = 0.01;
   modele = @(u) norm( phit( W*y(:,u) + B ) -y(:,u) -xi(y(:,u))  , 2);
  
   I = 0;
   for k=1:N
       I = I + h.*modele(k); % k correspond au rang de l'instant d'évaluation, qui vaut k*h
   end
end


res = H(Wstar,y,B,phit,xi);

pas = 0.005; % choix du pas à revoir


for k=1:Niter
   for i=1:n
       for j=1:n
           U(i,j) = U(i,j)-pas*dH(i,j,U,y,B,dphi,phit,xi);
       end
   end
end


res2 = U
h = 0.01;
Npas = T/h;
tspan = (0:Npas)*h;


s = zeros(n,Npas+1); % 1 ligne par composante, 1 colonne par instant t = j*h
s(:,1) = 0.25* (ones(n,1) - 0.5* (1:n)'/ (n-1) ) ;


for k=1:Npas
   s(:,k+1) = s(:,k) + h.* (U*s(:,k) + B);
end


if (1)
   plot(tspan,y(1,:),'g');
   hold on
   plot(tspan,s(1,:),'r');
   hold off
   legend('y','s', 'Location', 'best', 'FontSize', 11);
end

eval_quali = norm(y-s,2)

R = (9 - 80/n)*ones(n,1) - floor( (1:n)'-(n/2)*ones(n,1) )/n;


C = -2*eye(n,n) + diag(ones(n-1,1),1) + diag(ones(n-1,1),-1);
xi = @(s) C*s + R - 0.5*sum(s)*y;