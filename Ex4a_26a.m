V = 34.3; %m3
k = 0.28; %m3/min
%design conditions
vas = 0.5;
qb = 6.72; %m3/min
xa = 1;
xb = 0.02;
%set point
x3s=0.04;
%%
%controller settings -- need to run 23iii and 25b to load values
%Cohen-Coon
%Kc = KcPIcc;
%tau = tauIcc;
%Ziegler-Nichols
Kc = KcPIzn;
tau = tauIzn;
%%
%Euler
h=0.1;  %step change
t=0;
tf=3000; 
x = zeros(3,1);
x(:,1) = 0.04; %start in steady state
z = 0;  %initially
T = zeros(tf,2);
for i = 1:tf+1 
    if i<=(10/h)+1
        xb = 0.02;
    else
        xb = 0.021;
    end
    va = vas+Kc*(x3s-x(3))+z*Kc/tau; %0<=va<=1
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
    f4 = x3s-x(3);
    f = [f1;f2;f3];
    %log each value in table T
    T(i,1) = t;
    T(i,2) = x(3);
    %next iteration
    x = x+h*f;
    t = t+h;
    z = z+h*f4;
end
%%
t = T(:,1);
x3 = T(:,2);
plot(t,x3)