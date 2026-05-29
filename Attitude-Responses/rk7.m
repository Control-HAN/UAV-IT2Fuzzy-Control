function dx=rk7(x,u,T,p)
k1=Nplant(x,u,p)*T;
k2=Nplant(x+k1*0.5,u,p)*T;
k3=Nplant(x+k2*0.5,u,p)*T;
k4=Nplant(x+k3,u,p)*T;
dx=x + ((k1+k4)/6+(k2+k3)/3);