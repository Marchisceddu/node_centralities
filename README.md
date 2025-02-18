# node_centralities
A MATLAB app for generating random graphs and analyzing node centralities in complex networks.

![Graph](assets/graph.png) ![Centrality](assets/centrality.png)

This project was created on MATLAB R2024b.

## Features  
- Generate random graphs:
    - **Erdős-Rényi**
    - **Preferential Attachment**
    - **Small World**
- Compute various centrality measures:
  - **Katz centrality**  
  - **Exponential Subgraph centrality**  
  - **Degree centrality**  
  - **Closeness centrality**
  - **Betweeness centrality**
  - **Eigenvector centrality**
  - **Pagerank centrality**
- Interactive GUI with visualization and sortable results table.  

## How to Open the App  
1. Clone the repository

2. Open MATLAB and navigate to the [`src/`](https://github.com/Marchisceddu/node_centralities/tree/main/src) project folder.

3. In the MATLAB Current Folder panel, locate the file node_centralities.mlapp.

4. Double-click on node_centralities.mlapp to open it in the App Designer.

5. Click the Run button (▶) in the App Designer toolbar to launch the application.

## Future Features  

The following features could be implemented in future updates:  

- [ ] **Temporal Network Visualization**  
  - Implement a **3D plot** to visualize the temporal network structure.  
  - Alternatively, create an **animation** looping through each time layer.  

- [ ] **Temporal Centrality Metrics**  
  - Extend the centrality computation by integrating **broadcast** and **receive** centrality.  
  - This **centralities** is already implemented in [`temp_net.m`](https://github.com/Marchisceddu/node_centralities/tree/main/src/temp_net.m) and tested in [`test_temp_net.m`](https://github.com/Marchisceddu/node_centralities/tree/main/src/test_temp_net.m).  
