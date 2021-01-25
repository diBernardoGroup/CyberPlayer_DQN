
% parameters for the group
global num_mpc mpc_target A indeces_neighbours

num_mpc = 4;
mpc_target = 4;

%adjacency matrix (num vp MPC + vp RL)
%complete graph
%last row is the cyber player
A = [0 1 1 1 ; 1 0 1 1 ; 1 1 0 1 ; 1 1 1 0];

%path graph
% A = [0 1 0 0 ; 1 0 1 0 ; 0 1 0 1 ; 0 0 1 0];

%ring graph
% A = [0 1 0 1 ; 1 0 1 0 ; 0 1 0 1 ; 1 0 1 0];

%star graph 4 center
%A = [0 0 0 1 ; 0 0 0 1 ; 0 0 0 1 ; 1 1 1 0];

%star graph 2 center
% A = [0 1 0 0 ; 1 0 1 1 ; 0 1 0 0 ; 0 1 0 0];

indeces_neighbours = find(A(mpc_target,:));
