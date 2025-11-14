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
