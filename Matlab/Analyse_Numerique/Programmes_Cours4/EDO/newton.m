function x=newton(t,h,yn)

x=yn+h*F(t,yn);
err=1;
eps=1e-12;

while err>eps,
      b=-Phi(t,x,h,yn);
      A=DPhi(t,x,h);
      y=A\b;
      x=x+y;
      err=norm(y);
end;

