close all
clear
A=[2 1;1 2];

x=rand(2,1);

for i=1:10
    y=A*x;
    x=y/norm(y);
    m=median(A*x./x);
end
x

