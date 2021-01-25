
function dx= state(~,x)
global a b g w vd rv eta theta_s theta_v current_type current_player

dx = [x(2);
      -(a(current_player)*x(1)^2+b(current_player)*x(2)^2-g(current_player))*x(2)-w(current_player,current_type)^2*x(1)-eta^(-1)*x(4);
      x(4)*(2*a(current_player)*x(1)*x(2)+w(current_player,current_type)^2);
      x(4)*(a(current_player)*x(1)^2+3*b(current_player)*x(2)^2-g(current_player))-x(3)-theta_s(current_player,current_type)*(x(2)-vd(current_type))-theta_v(current_player,current_type)*(x(2)-rv(current_type))];
end