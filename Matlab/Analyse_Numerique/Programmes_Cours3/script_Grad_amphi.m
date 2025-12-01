clear; close all;

f = @(x,y) (sqrt(x.^2+y.^2)- 1).^2 +0.5*x+1;
grad = @(x,y) [2*(sqrt(x.^2+y.^2)- 1).*x./sqrt(x.^2+y.^2)+0.5 ; 2*(sqrt(x.^2+y.^2)- 1).*y./sqrt(x.^2+y.^2)];

N = 100;
p = 0.2;


[x,y] = meshgrid(linspace(-2,1.5,N),linspace(-1.3,1.3,N));
figure
title('Gradient a pas fixe p = 0.2')
%figure('position',[0 0 2000 1000])
subplot 121
s = surf(x,y,f(x,y));
s.EdgeColor = 'none';
shading('flat')
view([12 48])
light('position',[5 -3 10])

colormap jet
axis equal
xlabel('x')
ylabel('y')

subplot 122
contourf(x,y,f(x,y),40,'k')
axis equal
xlabel('x')
ylabel('y')

x = [0.1;-0.1];






for i = 1 : 80
    
    subplot 121
    hold on
    plot3(x(1),x(2),f(x(1),x(2))+0.05,'+r','LineWidth',3);
    
    subplot 122
    hold on
    plot(x(1),x(2),'+r','LineWidth',3);
    if i<6
        pause;
        disp('Press enter')
    else
        pause(0.05);
    end
    
    x = x - p*grad(x(1),x(2));
    
    
    
end

x = [1.4;1];

for i = 1 : 80w
    

    
     subplot 121
    hold on
    plot3(x(1),x(2),f(x(1),x(2))+0.05,'+g','LineWidth',3);
    
    subplot 122
    hold on
    plot(x(1),x(2),'+g','LineWidth',3);
    if i<5
        pause;
        disp('Press enter')
    else
        pause(0.051);
    end
    
    x = x - p*grad(x(1),x(2));
    
   
    
end

x = [1.4;0];

for i = 1 : 80
    
        subplot 121
    hold on
    plot3(x(1),x(2),f(x(1),x(2))+0.05,'+b','LineWidth',3);
    
    subplot 122
    hold on
    plot(x(1),x(2),'+b','LineWidth',3);
    if i<5
        pause;
        disp('Press enter')
    else
        pause(0.05);
    end
    
    
    x = x - p*grad(x(1),x(2));
    
    
    
end