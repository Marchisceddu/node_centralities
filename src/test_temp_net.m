% TEST_TEMP_NET generates M adjacency matrices from a chosen network model,
% stores them in a tensor T, prompts the user for m important nodes,
% and computes their broadcast and receive centralities using temp_net.

% Prompt user for number of layers
M = input("Enter the number of layers: ");

% Ensure valid network type selection
type = 0;
while type <= 0 || type > 3
    disp("Select the network type, enter:");
    disp("1. For smallw.");
    disp("2. For erdrey.");
    disp("3. For pref.");
    type = input("Choice: ");
end

n = 10; % Number of nodes per layer

% Create tensor T
T = zeros(n, n, M);

% Generate network layers based on selected type
for i = 1:M
    switch type
        case 1
            T(:, :, i) = smallw(n);
        case 2
            T(:, :, i) = erdrey(n);
        case 3
            T(:, :, i) = pref(n);
    end
end

% Prompt user for number of important nodes
m = 0;
while m <= 0 || m > 10
    m = input("Enter the number of important nodes to identify (1 to 10): ");
end

% Compute centrality measures
[i_br, val_br, i_rc, val_rc] = temp_net(T, m);

% Display results
disp("Broadcast Centrality:");
disp("Nodes:");
disp(i_br);
disp("Centrality Values:");
disp(val_br);

disp("Receive Centrality:");
disp("Nodes:");
disp(i_rc);
disp("Centrality Values:");
disp(val_rc);
