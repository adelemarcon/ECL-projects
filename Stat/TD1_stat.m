V = [1150, 1500, 1700, 1800, 1800, 1850, 2200, 2700, 2900, 3000, 3100, 3500, 3900, 4000, 5400];
m = mean(V)
sigma = sqrt(var(V))


n= 15

a = 0.05
q = tinv(1-a/2,n-1)
amp = 2*q*sigma/sqrt(n)

while amp>500
    n = n + 1
    q = tinv(1-a/2,n-1)
    amp = 2*q*sigma/sqrt(n)
end

%%
A = [59.50, 59.50, 57.60, 59.70, 59.80, 60.00, 60.20, 60.30, 60.50, 60.70, 60.80, 61.00, 61.00, 61.40, 61.50, 61.50, 61.70, 61.90, 62.00, 62.40, 62.50, 62.70, 63.00];
m = mean(A);
variance = var(A);
sigma = sqrt(variance);

n = 23;

a = 0.1;
q2 = chi2inv(1-a/2,n-1);
q1 = chi2inv(a/2,n-1);
confidenceInterval = [(n-1)*variance/q2, (n-1)*variance/q1]
