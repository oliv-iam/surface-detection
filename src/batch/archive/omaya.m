% setup environment
addpath src
addpath src/cnn2d
addpath src/batch

load("workspaces/data_composed_norm.mat")
maya_kfold(10, data, "users");
