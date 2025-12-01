function [y,d] = f(x)
y = exp(-2*x) - 2*exp(-x);
d = -2*exp(-2*x) + 2*exp(-x);
end