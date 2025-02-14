function x = exp_sub_centrality(graph_input)

% EXP_SUB_CENTRALITY Calculates the Subgraph Centrality for each node in a graph.
%
%   Input   G:    Graph object or adjacency matrix representing the network.
%
%   Output  x:    A column vector of Subgraph Centrality scores for each node in the graph.
%
%   Description:    This function computes the Subgraph Centrality (SC) of each node in the graph.
%                   Subgraph Centrality is a measure of a node's importance based on its participation 
%                   in small subgraphs. It gives higher importance to nodes that are part of many 
%                   small, tightly connected subgraphs.
%
%                   The algorithm uses the Lanczos method to efficiently compute the matrix exponential,
%                   which is a key component in calculating Subgraph Centrality. This approach provides
%                   a computationally efficient way to estimate the centrality scores.
%
%   Example: x = exp_sub_centrality(G); % Calculate Subgraph Centrality centrality for graph G
%   Example: x = exp_sub_centrality(A); % Calculate Subgraph Centrality centrality for adjacency matrix A

    % Check if graph_input is a graph object with adjacency matrix
    if isa(graph_input, 'graph')
        A = adjacency(graph_input);
    else
        A = graph_input;
    end
    
    % Get number of nodes
    n = size(A, 1);
    
    % Preallocate centrality scores vector
    x = zeros(n, 1);
    
    % Compute Subgraph Centrality for each node
    for i = 1:n
        % Initialize parameters
        u = zeros(n, 1);
        u(i) = 1;  % Set target node
        
        J = zeros(n+1);             % Lanczos tridiagonal matrix
        U = zeros(n, n+1);          % Orthonormal eigenvector matrix
        U(:,1) = u;                 % Initial vector
            
        betaa = 0;                  % Beta coefficient
        u0 = zeros(n, 1);           % Previous vector storage
        
        % Algorithm control parameters
        flag = 1;                   % While loop condition
        k = 0;                      % Iteration counter
        kmax = n;                   % Maximum iterations
        tau = 1e-6;                 % Convergence tolerance
        g = 0;                      % Subgraph centrality initialization
        
        % Lanczos Algorithm main loop
        while flag
            k = k + 1;              % Increment iteration counter
            g0 = g;                 % Store previous g value
            
            % Compute alpha coefficient
            alpha = u' * A * u;     % Projection of A along u
        
            % Orthonormalization: generate new utilde vector
            utilde = A * u - alpha * u - betaa * u0;
        
            % Compute beta coefficient
            betaa = norm(utilde);   % Norm of new utilde vector
        
            % Update vectors for next iteration
            u0 = u;                 % Store current vector
            if betaa < 1e-10
                warning('Beta is numerically unstable!');
            else
                u = utilde / betaa; % Normalize new vector
            end
        
            % Update tridiagonal matrix J
            J(k, k) = alpha;
            J(k, k+1) = betaa;
            J(k+1, k) = betaa;
        
            % Update orthonormal eigenvector matrix U
            U(:, k+1) = u;
        
            % Extract reduced matrices for exponential computation
            Uk = U(:, 1:k);         % Submatrix with first k orthonormal vectors
            Jk = J(1:k, 1:k);       % Reduced tridiagonal submatrix
        
            % Compute matrix exponential
            E = expm(Jk);
        
            % Extract Subgraph Centrality value
            g = E(1, 1);
        
            % Stopping criteria: max iterations or convergence
            flag = k < kmax && abs(g - g0) > abs(g) * tau;
        end
        
        % Store centrality score for current node
        x(i) = g;
    end

end