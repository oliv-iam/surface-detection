% setup environment
addpath src
addpath src/cnn2d
addpath src/gan
addpath src/batch
load("workspaces/data_composed_raw.mat");
c = parcluster('cpu-q');

job = batch(c, @gan_kfold, 0, {10, data, "raw"}, 'Pool', 10);
wait(job);

diary(job);
delete(jobs{i});
