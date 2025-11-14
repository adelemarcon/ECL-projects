clear all;
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

A = [2, -1, 0; -1,2,1; 0, -1, 2]