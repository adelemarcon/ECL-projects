%% Hilbert
% Parametres
d=15;

% Initialisations
H=hilb(d);
x_exact=ones(d,1);
scmb=H*x_exact;

% Resolution
sol=H\scmb;
sol
norme_difference=norm(sol-x_exact)

%% LUfleches

clear
close all

N=500;
alpha=N+1;
A1=alpha*eye(N,N);
A1(1,:)=1;
A1(:,1)=1;
A1(1,1)=alpha;

A2=alpha*eye(N,N);A2(end,:)=1;A2(:,end)=1;A2(end,end)=alpha;


[L1,U1]=lu(A1);
[L2,U2]=lu(A2);


subplot(2,3,1)
spy(A1)
title('A1')
subplot(2,3,2)
spy(L1)
title('L1')
subplot(2,3,3)
spy(U1)
title('U1')

subplot(2,3,4)
spy(A2)
title('A2')
subplot(2,3,5)
spy(L2)
title('L2')
subplot(2,3,6)
spy(U2)
title('U2')

%% Puissance1
close all
clear
A=[2 1;1 2];

x=rand(2,1);

for i=1:10
    y=A*x;
    x=y/norm(y);
    m=median(A*x./x);
end
x

%% Puissance 2

close all
clear
A=[0 1;1 0];

x=rand(2,1);
lam=[];
for i=1:100
    x=A*x;
    x=x/norm(x);
    m=median(A*x./x);
end

m

