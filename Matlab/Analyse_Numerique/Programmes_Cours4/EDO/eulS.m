function [y,t]=eulE(y0,h,T);

y=[y0];
yy=y0;
t=[0];
N=floor(T/h);
tt=0;
for i=1:N,
    Z=F(tt,yy);
    yy(1)=yy(1)+h*Z(1);
    Z=F(tt,yy);
    yy(2)=yy(2)+h*Z(2);
    tt=tt+h;
	y=[y,yy];
	t=[t,tt];
end;


