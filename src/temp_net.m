function [i_br, val_br, i_rc, val_rc] = temp_net(T, m)
    % TEMP_NET    computes broadcast and receive centrality in temporal networks.
    %             The method constructs a resolvent-based model to compute centrality measures.
    %
    %   Input     T - A 3D tensor containing M temporal adjacency matrices A[k], k = 1, ..., M.
    %             m - Number of important nodes to identify.
    %
    %   Output    i_br, val_br - Indices and values of the broadcast centrality.
    %             i_rc, val_rc - Indices and values of the receive centrality.

    % Get tensor dimensions
    [n1, n2, n3] = size(T);

    % Ensure adjacency matrices are square
    if n1 ~= n2
        error('Adjacency matrices must be square.');
    end

    % Compute spectral radius for each adjacency matrix
    A = cell(1, n3); % Store adjacency matrices
    rho_vec = zeros(n3, 1);
    for i = 1:n3
        A{i} = T(:, :, i);
        rho_vec(i) = eigs(A{i}, 1, 'largestabs'); % Spectral radius of matrix A{i}
    end
    rho = max(rho_vec); % Maximum eigenvalue across all matrices
    alpha = 0.9 / rho; % Ensure alpha is in the convergence range (0 < alpha < 1/rho)
 
    % Construct matrix B for resolvent computation
    B = zeros(n1 * n3);
    for i = 1:n3
        % Place scaled adjacency matrix in block-diagonal positions
        B(i * n1 - n1 + 1:i * n1, i * n1 - n1 + 1:i * n1) = alpha * A{i};
        % Add identity matrices to link consecutive time layers
        if i < n3
            B(i * n1 - n1 + 1:i * n1, i * n1 + 1:i * n1 + n1) = eye(n1);
        end
    end

    % Compute broadcast centrality
    e = [zeros((n3 - 1) * n1, 1); ones(n1, 1)]; % Unit vector targeting last time slice
    x_big = (eye(n1 * n3) - B) \ e; % Solve the resolvent equation
    x = x_big(1:n1); % Extract Q[1,M] centrality values

    % Sort nodes by broadcast centrality
    [xs, is] = sort(x, 'descend'); 
    i_br = is(1:m); % Top m indices
    val_br = xs(1:m); % Corresponding centrality values

    % Compute receive centrality
    e = [ones(1, n1), zeros(1, (n3 - 1) * n1)]; % Unit vector targeting first time slice
    x_big = (eye(n1 * n3) - B)' \ e'; % Solve transposed resolvent equation
    x = x_big(n1 * (n3 - 1) + 1:n1 + n1 * (n3 - 1)); % Extract Q[M,1] centrality values

    % Sort nodes by receive centrality
    [xs, is] = sort(x, 'descend'); 
    i_rc = is(1:m); % Top m indices
    val_rc = xs(1:m); % Corresponding centrality values

end
