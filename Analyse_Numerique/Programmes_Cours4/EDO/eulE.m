function [y,t]=eulE(y0,h,T)

y=[y0];
yy=y0;
t=[0];
N=floor(T/h);
tt=0;
for i=1:N,
    yy=yy+h*F(tt,yy);
    tt=tt+h;
	y=[y,yy];
	t=[t,tt];
end


