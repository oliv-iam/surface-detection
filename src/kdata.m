function data = kdata()
	data = cell(1, 5);
	for i = 1:5
		% get filenames and labels
		filenames = readlines("sequences/set1_filenames_" + i + ".txt");
		filenames = fullfile("sequences/set1", filenames(1:end-1));
		labels = readlines("sequences/set1_labels_" + i + ".txt");
		labels = labels(1:end-1);

		% load matrices
		data{i} = loader(filenames, labels, "", 128, 2)
	end
end
