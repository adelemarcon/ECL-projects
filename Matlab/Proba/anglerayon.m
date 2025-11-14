function [x,y] = anglerayon(N);
    theta = unifrnd(0,2*pi,1,N)
    r = unifrnd(0,1,1,N)
    x = r*cos(theta)
    y = r*sin(theta)
end