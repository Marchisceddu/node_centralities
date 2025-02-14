function x = katz_centrality(graph_input, num_alpha)

% KATZ     Calculates the Katz centrality for a graph given its adjacency matrix or graph object.
%
%   Input   graph_input: Graph object or adjacency matrix.
%           num_alpha:   A scalar value representing the Katz centrality parameter, typically a small positive value.
%                        Default value is 0.85 if not provided.
%
%   Output  x:      A column vector of Katz centrality scores for each node in the graph.
%
%   Description:    This function computes the Katz centrality of each node in the graph, which is a measure
%                   of the influence of a node based on the number and weight of the paths leading to it. 
%                   The Katz centrality assigns higher scores to nodes that are connected to many other nodes,
%                   as well as those that are connected to nodes with high centrality. The centrality is computed
%                   using the formula: x = (I - alpha * A)^(-1) * 1, where:
%                   - I is the identity matrix.
%                   - A is the adjacency matrix of the graph.
%                   - alpha is a parameter controlling the influence of distant nodes.
%
%                   The parameter alpha should be chosen carefully to ensure the convergence of the series sum.
%                   A typical choice for alpha is a value smaller than the inverse of the largest eigenvalue
%                   of the adjacency matrix to ensure convergence.
%  
%   Example: x = katz_centrality(G, 0.1); % Calculate Katz centrality with alpha = 0.1 for graph G
%   Example: x = katz_centrality(G, 0.1); % Calculate Katz centrality with alpha = 0.1 for adjacency matrix A

    % Set default alpha if not provided
    if nargin < 2
        num_alpha = 0.95;
    end

    % Check if graph_input is a graph object with adjacency matrix
    if isa(graph_input, 'graph')
        A = adjacency(graph_input);
    else
        A = graph_input;
    end

    n = size(A, 1);
    I = eye(n);

    lambda_max = eigs(A, 1, 'largestabs');
    
    alpha = num_alpha / lambda_max;

    x = (I - alpha * A) \ ones(n, 1); % Katz centrality calculation
end