% setup environment
addpath src
addpath src/cnn2d
addpath src/batch

load("workspaces/data_abnormal_paper.mat");
c = parcluster('cpu-q');

job = batch(c, @paper_kfold, 0, {10, data}, 'Pool', 10);
wait(job);
diary(job);
delete(job);
