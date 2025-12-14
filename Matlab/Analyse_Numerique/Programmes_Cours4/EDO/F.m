function y=F(t,x);

y=zeros(size(x));
y(1)=x(2);
y(2)=-sin(x(1));
%y(2)=-x(1);