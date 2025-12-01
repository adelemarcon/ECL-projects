
clear; close all;

t = [0.5 2 0.5
     0 0 1.5];
 
 
 eps = 2;
 
 [x,y] = meshgrid(linspace(-3,3,100),linspace(-3,3,100));
 
 
 h1 = fill(t(1,:),t(2,:),[0.8 0.8 1],'LineWidth',1);
 title('Gradient vs Gradient penalis\''e','Interpreter','latex','FontSize',15)
 hold on
 [~,h2] = contour(x,y,x.^2+y.^2,100,'k','LineWidth',0.1);
 plot([-1 3],[0 0],'k--')
 plot([0 0],[-1 1.7],'k--')
 axis([-0.2 2.2 -0.2 1.7])
 %axis equal
 
 Niter = 50;
 x0 = [0.7;1.2];
 h3 = plot(x0(1),x0(2),'r+','LineWidth',2);
 
 
 
 
 x = x0;
 p = 0.05;
 for i = 1 : Niter
     if i<6
        pause; 
     else
        pause(0.1);  
     end
     x = x - 2*p*x;
     plot(x(1),x(2),'r+','LineWidth',2)
     
 end
 h4 = legend([h1 h2 h3],{'$K$','$f(x_1,x_2)$','Gradient'},'Interpreter','latex','FontSize',15);
 disp('press Enter')
 pause;
 
 x = x0;
 h5 = plot(x0(1),x0(2),'o','LineWidth',3,'MarkerEdgeColor',[0 0.5 0]);
 delete(h4)
 for i = 1 : Niter
     if i<6
        pause; 
     else
        pause(0.1);  
     end
     x = x - 2*p*x - 1/eps*[(2*x(1) - 1)*(x(1)<0.5) ; 0];
     pause(0.1);
     plot(x(1),x(2),'go','LineWidth',3,'MarkerEdgeColor',[0 0.5 0])
      
 end
 
 h4 = legend([h1 h2 h3 h5],{'$K$','$f(x_1,x_2)$','Gradient','Gradient penalis\''e'},'Interpreter','latex','FontSize',15);
