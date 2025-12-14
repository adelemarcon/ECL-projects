function y=eulI(y0,h,T);

y=[y0];
yy=y0;
N=floor(T/h);
t=0;

for i=1:N,
    yy=newton(t,h,yy);
    y=[y,yy];
    t=t+h;
end;


