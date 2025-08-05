% random 80/20 split
function [dataset_train, dataset_test] = testset(data)
	full = [data{1}; data{2}; data{3}; data{4}; data{5}];
	n_train = round(height(full)*0.8);
	idxs_train = randi(height(full), n_train, 1);
	dataset_train = full(idxs_train, :);
	idxs_test = true(height(full), 1);
	idxs_test(idxs_train) = false;
	dataset_test = full(idxs_test);
end
