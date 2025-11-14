clear
close all

N=500;
alpha=N+1;
A1=alpha*eye(N,N);
A1(1,:)=1;
A1(:,1)=1;
A1(1,1)=alpha;

A2=alpha*eye(N,N);A2(end,:)=1;A2(:,end)=1;A2(end,end)=alpha;


[L1,U1]=lu(A1);
[L2,U2]=lu(A2);


subplot(2,3,1)
spy(A1)
title('A1')
subplot(2,3,2)
spy(L1)
title('L1')
subplot(2,3,3)
spy(U1)
title('U1')

subplot(2,3,4)
spy(A2)
title('A2')
subplot(2,3,5)
spy(L2)
title('L2')
subplot(2,3,6)
spy(U2)
title('U2')

