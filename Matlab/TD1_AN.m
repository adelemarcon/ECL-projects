clear all;
close all;
clc;

d = 10
alpha = 1e-2
max_iter = 10000

b = ones(d, 1)
A = zeros(d,d);
for i = 1:d
    for j = 1:d
        if i == j;
            A(i, j)= 2;
        end
        if i == j + 1
            A(i, j) = -1;
        end
        if i == j - 1
            A(i, j) = -1;
        end
    end
end


X0 = zeros(d,1);
X = X0;

X_history = zeros(d, max_iter + 1);
X_history(:, 1) = X;

for n = 1:max_iter
    X_new = X - alpha * (A * X - b);
    X_history(:, n + 1) = X_new;
    X = X_new;
end