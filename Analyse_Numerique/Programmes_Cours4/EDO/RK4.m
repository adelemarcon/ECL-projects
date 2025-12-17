function y=RK4(y0,h,T)
y=[y0];
yy=y0;
N=floor(T/h);
t=0;
for i=1:N
    k1=F(t,yy);
	k2=F(t+h/2,yy+h/2*k1);
	k3=F(t+h/2,yy+h/2*k2);
	k4=F(t+h,yy+h*k3);
    yy=yy+h/6*(k1+2*k2+2*k3+k4);
    y=[y,yy];
	t=t+h;
end
