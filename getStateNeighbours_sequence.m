function [x_neighbours] = getStateNeighbours_sequence(x_mpc, x_rl)

    global indeces_neighbours num_mpc
    
    x_neighbours = [];
    
    for j=1:num_mpc-1
        if ismember(j, indeces_neighbours)
            x_neighbours = [x_neighbours x_mpc(j, :)];
        end
    end
    x_neighbours = [x_neighbours repmat(x_rl,1,num_mpc-length(indeces_neighbours)-1)];
    
end

