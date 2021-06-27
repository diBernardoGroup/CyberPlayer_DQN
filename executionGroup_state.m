
clc
clear
close all

global actions dt_MPC
global num_mpc mpc_target A indeces_neighbours

parameters;
parametersGroup;
parametersOptimalControl;

% actions
% minus is move to left, plus is move to right
% action is an acceleration
accLim = 4;
actions = [-accLim, -accLim/2, -accLim/4, -accLim/8, 0, accLim/8, accLim/4,  accLim/2,  accLim];
num_states = (num_mpc-1)*4; %dimensionality of state space


% load Q network
load('Q_nn_1500trials.mat');


num_trials = 50;
all_keep_data =  [];

for j=1:num_trials
    
    disp(['num trial: ' num2str(j)]);
    
    % change network for the next trial
    A = randi(2,num_mpc,num_mpc)-1;
    A = A - tril(A,-1) + triu(A,1)'; % undirected
    A = A - diag(diag(A));           % diag is zero
    while(sum(any(A,2)) ~= num_mpc) % check on disconnected network
        A = randi(2,num_mpc,num_mpc)-1;
        A = A - tril(A,-1) + triu(A,1)'; % undirected
        A = A - diag(diag(A));           % diag is zero
    end
    indeces_neighbours = find(A(mpc_target,:));
    disp(['neighbours: ' num2str(indeces_neighbours)]);
    
    %init
    x_rl = zeros(1,2); %pos, vel
    x_mpc = zeros(num_mpc, 2); %pos, vel
    u_rl = 0;

    index_markov_chain = [5 6 7 4];
    for i=1:num_mpc
        x_mpc_ref(i, :, :) = generationReference(index_markov_chain(i));
        vel_x_mpc_ref(i, :) = x_mpc_ref(i, 2, :);
    end
    
    Nu = size(x_mpc_ref,3);
    keep_data = zeros(7, Nu);

    RMS_x_rl = zeros(num_mpc-1,1);
    RMS_x_mpc_target = zeros(num_mpc-1,1);
    

    tic;
    currentToc = toc;
    previousToc = currentToc;

    for i=1:Nu
        for n=1:num_mpc
            mean_pos = sum(A(n,:).*x_mpc(:, 1)')/sum(A(n,:));
            mean_vel = sum(A(n,:).*x_mpc(:, 2)')/sum(A(n,:));
            group = [mean_pos mean_vel];           
             
            % type = 1 if leader, type = 2 if follower, type 3 = joint improvisation
            new_x_mpc(n, :) = virtualPlayerOptimalControl(x_mpc(n,:), group, vel_x_mpc_ref(n,i), n, 3);
        end
        
        % last parameter specify if the VP is learning or not: 1 if it is learning, 0 otherwise
        % suppose player 4 is the target
        x_mpc_target = x_mpc(mpc_target, :);
        new_x_mpc_target = new_x_mpc(mpc_target, :);
        
        x_mpc_neighbours = getStateNeighbours_sequence(x_mpc, x_rl);
        
        % type = 1 if leader, type = 2 if follower, type 3 = joint improvisation
        % last parameter specify if the VP is learning or not: 1 if it is learning, 0 otherwise
		[new_x_rl, u_rl] = virtualPlayerRL(x_rl, x_mpc_neighbours, Q_nn, mpc_target, 3, 0);

        x_mpc = new_x_mpc;
        x_rl = new_x_rl;

        keep_data(1,i) = x_rl(1);
        keep_data(2,i) = x_mpc(1, 1);
        keep_data(3,i) = x_mpc(2, 1);
        keep_data(4,i) = x_mpc(3, 1);
        keep_data(5,i) = x_mpc(4, 1);
        keep_data(6,i) = sum(A(mpc_target,:).*x_mpc(:, 1)')/sum(A(mpc_target,:));
        keep_data(7,i) = currentToc;            
        keep_data(8,i) = u_rl;               


        x_mpc_no_target = x_mpc(:,1);
        x_mpc_no_target(mpc_target) = [];
        for n=1:length(x_mpc_no_target)
            if ismember(n,indeces_neighbours)
                RMS_x_rl(n) = RMS_x_rl(n)+((x_rl(1)- x_mpc_no_target(n)).^2);
                RMS_x_mpc_target(n) = RMS_x_mpc_target(n)+((x_mpc_target(1)-x_mpc_no_target(n)).^2);
            end
        end
        
        currentToc = toc;
        while(currentToc - previousToc < dt_MPC)
            currentToc = toc;
        end

        previousToc = currentToc;

    end
    
    all_keep_data = [all_keep_data keep_data];
    disp(['RMS rl: ' num2str(sqrt(RMS_x_rl/Nu)')]);
    disp(['RMS mpc: ' num2str(sqrt(RMS_x_mpc_target/Nu)')]);

end

save('example_dataset.mat', 'all_keep_data');
save('example_trial.mat', 'keep_data');
