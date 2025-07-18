% setup environment
addpath src
addpath src/cnn2d
addpath src/batch
load("workspaces/data_composed_raw.mat");
c = parcluster('cpu-q');

% kfold: stacks
jobs = cell(1, 4);
for i = 1:4
	n = i+1;
	id = n*2;
	jobs{i} = batch(c, @stacks_kfold, 0, {10, data, n, "50x" + num2str(id) + "x1"}, 'Pool', 10);
end
for i = 1:4
	wait(jobs{i});
end

% print output
for i = 1:4
	fprintf("Job %d:\n", (i+1)*2);
	diary(jobs{i});
	delete(jobs{i});
end
