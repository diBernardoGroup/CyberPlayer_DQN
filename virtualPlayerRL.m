function [new_x_rl, U] = virtualPlayerRL( x_rl, x_mpc, Q_nn, n, type, isLearning)

    global epsilon min_epsilon
    global xa xb substeps dt_RK
    global actions
    
    % z is the state made up of [pos_other vel_other err_pos err_vel] between MPC and RL
    z = [x_mpc repmat(x_rl,1,size(x_mpc,2)/2)-x_mpc];

    % PICK AN ACTION
    if isLearning
        if rand() > epsilon
             % NN accepts column
            [~,aIdx] = max(Q_nn(z')); % Pick the action the Q matrix thinks is best!
        else
            aIdx = randi(length(actions),1); % Random action!
        end
    else
        if rand() > min_epsilon
             % NN accepts column
            [~,aIdx] = max(Q_nn(z')); % Pick the action the Q matrix thinks is best!
        else
            aIdx = randi(length(actions),1); % Random action!
        end
    end
    
    U = actions(aIdx);

    % STEP DYNAMICS FORWARD
   for i = 1:substeps
        k1 = HKB(x_rl, U, n, type);
        k2 = HKB(x_rl+dt_RK/2*k1, U, n, type);
        k3 = HKB(x_rl+dt_RK/2*k2, U, n, type);
        k4 = HKB(x_rl+dt_RK*k3, U, n, type);
        
        new_x_rl = x_rl + dt_RK/6*(k1 + 2*k2 + 2*k3 + k4);  

        % I add the constrains
        if new_x_rl(1) > xb
            new_x_rl(1) = xb;
        elseif new_x_rl(1) < xa
            new_x_rl(1) = xa;
        end
   end
   
end

