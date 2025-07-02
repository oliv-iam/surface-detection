addpath src
addpath src/models
addpath src/dataset   

load("workspaces/data.mat");
kfold(5, data);
