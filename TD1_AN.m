^clear all;
close all;
clc;

d = 10;
alpha = 1e-2;
max_iter = 10000;

b = ones(d, 1);
un = ones(d-1,1);
A = 2*eye(d) - diag(un,1) - diag(un,-1);


X0 = zeros(d,1);
X = X0;

X_history = zeros(d, max_iter + 1);
X_history(:, 1) = X;

for n = 1:max_iter
    X_new = X - alpha * (A * X - b);
    X_history(:, n + 1) = X_new;
    X = X_new;
end

%%
clear all;
close all;
clc;

A = [2, -1, 0; -1,2,1; 0, -1, 2];
B = [0,3,-1;4,-1,-1;-4,3,3];
C = B*B;
x=rand(3,1);

for i=1:20
    y=C*x;
    x=y/norm(y);
    m=median(C*x./x);
end

v1 = [-1,sqrt(2),-1]';
u1 = v1';
lambda = 2 + sqrt(2);

A1 = A - lambda*v1*u1./u1*v1;

for i=1:20
    y=A1*x;
    x=y/norm(y);
    m=median(A1*x./x);
end