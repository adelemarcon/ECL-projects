n = 5;
N = 1000;
theta = 10;
T1 = [];
T2 = [];

for i=1:N
    x = unifrnd(0,theta,1,20);
    T1 = [T1;max(x)];
    T2 = [T2;2*mean(x)];
end

subplot(2,2,1)
histogram(T1,'normalization','probability');

subplot(2,2,2)
histogram(T2,'normalization','probability');

subplot(2,2,3)
boxplot(T1)

subplot(2,2,4)
boxplot(T2)
