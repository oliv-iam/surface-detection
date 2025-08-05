% setup environment
addpath src
addpath src/cnn2d
addpath src/batch
load("workspaces/data_composed_raw.mat");
c = parcluster('cpu-q');

% kfold: oversampling
jobs = cell(1:6);
for i = 1:6
	j = i-1;
	jobs{i} = batch(c, @sample_kfold, 0, {10, data, j*0.2, num2str(j*20)}, 'Pool', 10);
end
for i = 1:6
	wait(jobs{i});
end

% print output
for i = 1:6
	fprintf("Job %d:\n", i);
	diary(jobs{i});
	delete(jobs{i});
end
