
function res = bcon(ya,yb)
global theta_p rp x0 current_type current_player

res = [ya(1)-x0(current_type, 1);
       ya(2)-x0(current_type, 2);
       yb(3)-theta_p(current_player,current_type)*(yb(1)-rp(current_type));
       yb(4)];
end