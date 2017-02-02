V = 34.3; %m3
k = 0.28; %m3/min
%design conditions
vas = 0.5;
qb = 6.72; %m3/min
xa = 1;
xb = 0.02;
%set point
x3s=0.04;
%Vary Kc
Kc = 187.2;
%%
%Euler
h=0.1;
t=0;
tf=3000;
x = zeros(3,1);
x(:,1) = 0.04; %start in steady state
T = zeros(tf,2);
for i = 1:tf+1 
    if i<=(10/h)+1  %step change after 10 min
        xb = 0.02;
    else
        xb = 0.021;
    end
    va = vas+Kc*(x3s-x(3)); %0<=va<=1
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
    T(i,2) = x(3);
    %next iteration
    x = x+h*f;
    t = t+h;
end
%%
t = T(:,1);
x3 = T(:,2);
plot(t,x3) %only asks for x3
axis([0,tf*h,0.03995,0.04025])
%%
%Ziegler-Nichols controller settings
Ku = Kc;
Pu = 18.7; 
%P controller
KcPzn = Ku/2;
%PI controller
KcPIzn = Ku/2.2;
tauIzn = Pu/1.2;