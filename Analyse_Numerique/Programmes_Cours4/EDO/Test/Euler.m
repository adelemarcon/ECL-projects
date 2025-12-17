clear
close all

T = 1;

N = 100;
h = T/N;
t = linspace(0,T,N+1);
u0 = 1;

u = zeros(1,N+1);
u(1) = u0;

for n = 1 : N
    u(n+1) = u(n) + h*f(t(n),u(n));
end

uexact = exp(t.^2);
plot(t,u,t,uexact)