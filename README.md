# Metaheuristic-Clustering-Initialization-Comparison
This repository contains the full implementation and experimental setup for the comparative study of metaheuristic clustering algorithms with different initialization strategies, specifically K-means and K-means++. It includes code for eight metaheuristic optimizers, dataset preprocessing, and evaluation metrics.

This was developed using MATLAB R2020a 

- The Dataset folder contains the 14 benchmark datasets
- Results folders are used to store algorithm results after running the algorithm:
  - `ResultsBaseline` (baseline approach)
  - `Results` (approach 1)
  - `Resultsh` (approach 2)
  - `Resultshp` (approach 3)
- The Algorithms folder contains the 8 metaheuristics algorithms' source codes that are shared by the creators of the algorithms   

**How to run the code: open this folder in Matlab project and run the 
- KMean and KMeanPlus for baseline 
- main script for metaheuristic algorithm (Approach 1)
- main_hybrid for k-means initialize metaheuristic (Approach 2)
- main_hybrid_plus for k-means++ initialize metaheuristic (Approach 3)

more details on code parts and how to add datasets will be found inside the code as comments
