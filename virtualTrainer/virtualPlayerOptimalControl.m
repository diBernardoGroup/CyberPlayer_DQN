
function [x] = virtualPlayerOptimalControl(x, x_other, x_ref, n, type)
    
    global vd dt_MPC rp rv x0
    global xa xb current_type current_player
    
    current_type = type;
    current_player = n;
    vd(type) = x_ref;

    x0(type, 1) = x(1);
    x0(type, 2) = x(2);
  
    rp(type) = x_other(1) + x_other(2)*dt_MPC;
    rv(type) = x_other(2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    solinit=bvpinit(linspace(0,dt_MPC,6),[x(1) x(2) 1 0]);
    options=bvpset('RelTol',1e-1);
    sol=bvp4c('state','bcon',solinit,options);
    xint = linspace(0,dt_MPC,100);
    Sxint = deval(sol,xint);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    num = 100;
    new_x = [Sxint(1,num) Sxint(2,num)];    
    
    if new_x(1) > xb
        new_x(1) = xb;
    elseif new_x(1) < xa
        new_x(1) = xa;
    end
    
    x = new_x;
end

