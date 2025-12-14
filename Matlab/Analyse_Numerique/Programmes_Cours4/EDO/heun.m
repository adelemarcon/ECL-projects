function y=heun(y0,h,T);

y=[y0];
yy=y0;
N=floor(T/h);
t=0;
for i=1:N,
    yy=yy+h/2*(F(t,yy)+F(t+h,yy+h*F(t,yy)));;
    y=[y,yy];
	t=t+h;
end;


