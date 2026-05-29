function dx = Nplant_local(x, u, p)
    global J Jr Jp Jy L Ktau Kf
    dx = zeros(6,1);
    
    dx(1) = x(2);
    dx(2) = (((Jp-Jy)/Jr)*x(6)*x(4)) + ((J/Jr)*x(4)*p) + ((Kf*L)/Jr)*(-u(2)+u(4));
    dx(3) = x(4);
    dx(4) = (((Jy-Jr)/Jp)*x(6)*x(2)) - ((J/Jp)*x(2)*p) + ((Kf*L)/Jp)*(-u(1)+u(3));
    dx(5) = x(6);
    dx(6) = (((Jr-Jp)/Jy)*x(2)*x(4)) + ((Ktau)/Jy)*(-u(1)+u(2)-u(3)+u(4));
end