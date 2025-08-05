% setup environment
addpath src
addpath src/cnn2d
addpath src/batch

load("workspaces/data_composed_norm.mat");
all_data = [data{1}; data{2}; data{3}; data{4}; data{5}];
all_kfold(10, all_data);
