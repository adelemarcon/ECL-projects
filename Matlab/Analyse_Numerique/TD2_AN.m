%% 
f = @(x) (x.^(-3/4)) .* (1 + x.^(2))
N = 1000;
a = 0;
b = 1;
h = (b-a)/N;

x = a + h:h:b;
Irect=h*sum(f(x))

f2 = @(u) 4*(1 +u.^8)

Irect2=h*sum(f2(x))
