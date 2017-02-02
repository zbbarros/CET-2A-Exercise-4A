V = 34.3; %m3
k = 0.28; %m3/min
%design conditions
vas = 0.5;
qb = 6.72; %m3/min
xa = 1;
%set point conditions
x3s = 0.04; %vary x3s in (b)
%%
%Euler
tf=1000;
x = zeros(3,1);
T = zeros(tf,9);
for j = 1:4
    h=0.1;
    t=0;
    x(:,1) = 0.04; %start in steady state
    Kc = [0 20 50 100];
    for i = 1:tf+1
        if i<=(10/h)+1  %step change after 10 min
            xb = 0.02;
        else
            xb = 0.03;
        end
        va = vas+Kc(j)*(x3s-x(3)); %0<=va<=1
        if va>1
            va = 1;
        else if va<0
                va = 0;
            end
        end
        qa = k*va;
        %dynamical mass balances
        f1 = (qa*xa+qb*xb-(qa+qb)*x(1))/V;
        f2 = ((qa+qb)*(x(1)-x(2)))/V;
        f3 = ((qa+qb)*(x(2)-x(3)))/V;
        f = [f1;f2;f3];
        %log each value in table T
        T(i,1) = t;
        T(i,j+1) = x(3);
        T(i,j+5) = va;
        %next iteration
        x = x+h*f;
        t = t+h;
    end
end
%%
t = T(:,1);
x31 = T(:,2);
x32 = T(:,3);
x33 = T(:,4);
x34 = T(:,5);
va1 = T(:,6);
va2 = T(:,7);
va3 = T(:,8);
va4 = T(:,9);

plot(t,x31,t,x32,t,x33,t,x34)
axis([0,tf*h,0.038,0.052])
legend('K_{c}= 0','K_{c}= 20','K_{c}= 50','K_{c}= 100','Location','northwest')

figure(2)
plot(t,va1,t,va2,t,va3,t,va4)
axis([0,tf*h,0.1,0.55])
legend('K_{c}= 0','K_{c}= 20','K_{c}= 50','K_{c}= 100','Location','southeast')