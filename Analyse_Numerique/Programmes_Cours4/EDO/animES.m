close all
clear

v = VideoWriter('ES.avi');
open(v);

N=1000;
T=100;

h=T/N;

y=eulS([1;0],h,T);
t=linspace(0,T,N+1);
NRJ=1/2*y(2,:).^2-cos(y(1,:));

for i=1:N+1
    subplot(1,2,1)
    plot([0,sin(y(1,i))],[0,-cos(y(1,i))],'b','LineWidth',4)
    hold on 
    plot(0,0,'b.','MarkerSize',20)
    plot(sin(y(1,i)),-cos(y(1,i)),'r.','MarkerSize',40)
    axis equal
    axis([-1.1,1.1,-1.1,1.1])
    hold off
    axis off
    title('Euler symplectique','FontSize',18)
    subplot(1,2,2)
    plot(t(1:i),NRJ(1:i),'LineWidth',4)
    axis([0,T,-1,5]);
    xlabel('Temps','FontSize',14)
    ylabel('Energie','FontSize',14)
    %pause(0.01)
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v)
