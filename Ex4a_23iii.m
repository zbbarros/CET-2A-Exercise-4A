V = 34.3; %m3
k = 0.28; %m3/min
%design conditions
qb = 6.72; %m3/min
xa = 1;
xb = 0.02;
va = 0.55; %step change from steady state at t=0
qa = k*va;
x3s = 0.04;
%%
%Euler
h=0.1;    %step size of 1 min
t=0;      %start at t=0
tf = 800;
x = zeros(3,1);
x(:,1) = 0.04;  %start in steady state
T = zeros(tf,4);
for i = 1:tf+1
    %dynamical mass balances
    f1 = (qa*xa+qb*xb-(qa+qb)*x(1))/V;
    f2 = ((qa+qb)*(x(1)-x(2)))/V;
    f3 = ((qa+qb)*(x(2)-x(3)))/V;
    f = [f1;f2;f3];
    %log each value in table T
    T(i,1) = t;
    T(i,2) = x(3)-x3s;
    T(i,3) = f3;
    %next iteration
    x = x+h*f;
    t = t+h;
end
%%
%Cohen-Coon: want to plot line with gradient I that passes through (tI,x3I)
I = max(T(:,3));
for j = 1:tf+1
    if I == T(j,3)      %find point with max gradient
        tI = T(j,1);    %record coordinates
        x3I = T(j,2);
    end
end
for k = 1:tf+1
    ti = T(k,1);
    y = I*(ti-tI)+x3I;  %equation of tangent
    T(k,4) = y;
end
t = T(:,1);
x3 = T(:,2);
tangent = T(:,4);
d=zeros(tf+1,1);
d(:,1) = x(3)-x3s;  %asymptote: only takes last value of x3
%calculate Cohen-Coon controller settings from graph
K = d(1,1)/0.05;    %output/input
dOut = d(1,1);      %asymptote value
%calculate td
for l = 1:tf+1
    td1 = T(l,4);
    td2 = T(l+1,4);
    t1 = T(l,1);
    if td1 < 0 & td2 > 0    %need to interpolate bc of step size
        td = t1-td1/I ;
        break
    end
end
%calculate tau
for m = 1:tf+1
    tau1 = T(m,4);
    tau2 = T(m+1,4);
    t2 = T(m,1);
    if tau1 < dOut & tau2 > dOut
        tau = (t2+(dOut-tau1)/I)-td;    %interpolate
        break
    end
end
v = [tau+td tau+td];    %intersection of tangent and asymptote
Y = [0 0.003];
plot(t,x3,t,tangent,'--',t,d,'--',v,Y,'--')
axis([0,tf*h,0,0.003])
%%
%P controller
KcPcc = (1/K)*((1/3)+(tau/td));
%PI controller
KcPIcc = (1/K)*((1/12)+0.9*(tau/td));
tauIcc = td*((30*tau+3*td)/(9*tau+20*td));