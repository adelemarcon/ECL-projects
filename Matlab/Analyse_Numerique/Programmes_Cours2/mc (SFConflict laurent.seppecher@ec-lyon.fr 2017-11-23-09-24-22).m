% Monte-Carlo
x=a+(b-a)*rand(N+1,1);
Imc=(b-a)/N*sum(f(x));
