function d1=fin_diff(v,h)
% 4th order finite difference scheme. Two first point estimated with
% forward formula, two last with bakcward formula, all the other with
% central formula.
%
% input:
% v - vector for differentiation; f(x)
% h - sampling rate; dx
% output:
% d1 - derivative of f(x); df/dx

v=v(:); 
d1_size=size(v,1);
d1=zeros(d1_size,1);

d1(1)=((-25/12)*v(1)+4*v(2)+(-3)*v(3)+(4/3)*v(4)+(-1/4)*v(5))/h;
d1(2)=((-25/12)*v(2)+4*v(3)+(-3)*v(4)+(4/3)*v(5)+(-1/4)*v(6))/h;
d1(3:end-2)=(1/12*v(1:end-4)+(-2/3)*v(2:end-3)+(2/3)*v(4:end-1)+(-1/12)*v(5:end))/h;
d1(end-1)=((1/4)*v(end-5)+(-4/3)*v(end-4)+3*v(end-3)+(-4)*v(end-2)+(25/12)*v(end-1))/h;
d1(end)=((1/4)*v(end-4)+(-4/3)*v(end-3)+3*v(end-2)+(-4)*v(end-1)+(25/12)*v(end))/h;

