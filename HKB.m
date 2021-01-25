
function [ xp ] = HKB( x,u,n,type)

    global a b g w

    %xp(1) is velocity, xp(2) is acceleration
    xp = zeros(1,2);
    
    xp(1) = x(2);
    xp(2) = -(a(n)*x(1)^2+b(n)*x(2)^2-g(n))*x(2)-w(n,type)^2*x(1) + u;

end