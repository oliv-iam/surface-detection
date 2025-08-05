% setup environment
addpath src
addpath src/cnn2d
addpath src/batch

load("workspaces/data_composed_raw.mat")
c = parcluster('cpu-q');

job = batch(c, @maya2_kfold, 0, {10, data, "users"}, 'Pool', 10);
wait(job);
diary(job);
delete(job);
