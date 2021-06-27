
% optimal control
global theta_p theta_s theta_v
% column 1 leader, 2 follower, 3 joint improvisation
% row i for the i-th player
theta_v = [0 0 0.05;
           0 0 0.05;
           0 0 0.05;
           0 0 0.05];
% different VTs
theta_p = [0.2 0.8 0.75;
           0.2 0.8 0.85;
           0.2 0.8 0.75;
           0.2 0.8 0.8]; 
theta_s = [0.8 0.2 0.2;
           0.8 0.2 0.1;
           0.8 0.2 0.2;
           0.8 0.2 0.15];

global eta
eta=10^(-4);

global x0 vd rp rv
x0 = [0 0; 0 0; 0 0];
vd = [0 0 0];
rp = [0 0 0];
rv = [0 0 0];

global dt_MPC
dt_MPC = 0.03;
