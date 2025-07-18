% setup environment
addpath src
addpath src/cnn2d
addpath src/batch
load("workspaces/data_composed_raw.mat");
c = parcluster('cpu-q');

% kfold: permutations
p1 = [1 2 3 4]; % AGAG
p2 = [1 2 4 3]; % AGGA
p3 = [1 3 2 4]; % AAGG
p4 = "rand";
perms = {p1, p2, p3, p4};

n1 = "1234";
n2 = "1243";
n3 = "1324";
names = {n1, n2, n3, p4};

jobs = cell(1:4);
for i = 1:4
	jobs{i} = batch(c, @permute_kfold, 0, {10, data, perms{i}, names{i}}, 'Pool', 10);
end
for i = 1:4
	wait(jobs{i});
end

% print output
for i = 1:4
	fprintf("Job %d:\n", i);
	diary(jobs{i});
	delete(jobs{i});
end
