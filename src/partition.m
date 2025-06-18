% labels, ratios -> indices 
function output = partition(classes, ratios)
	idx_train = [];
	idx_val = [];
	idx_test = [];

	% loop through each class to stratify
	for i = 1:5
		% find and shuffle indices
		cls_idx = classes{i};
		n = numel(cls_idx);
		cls_idx = cls_idx(randperm(n));
		
		% split
		n_train = round(ratios(1) * n);
		n_val = round(ratios(2) * n);

		idx_train = [idx_train; cls_idx(1:n_train)];
		idx_val = [idx_val; cls_idx(n_train+1 : n_train+n_val)];
		idx_test = [idx_test; cls_idx(n_train+n_val+1 : end)];
	end

	% shuffle overall
	idx_train = idx_train(randperm(numel(idx_train)));
	idx_val = idx_val(randperm(numel(idx_val)));
	idx_test = idx_test(randperm(numel(idx_test)));
	output = {idx_train, idx_val, idx_test};

end
