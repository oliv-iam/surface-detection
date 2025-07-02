function data = kdata(set, length, channels)
	data = cell(1, 5);
	for i = 1:5
		% get filenames and labels
		filenames = readlines("sequences/lists/" + set + "_filenames_" + i + ".txt");
		filenames = fullfile("sequences/" + set, filenames(1:end-1));
		labels = readlines("sequences/lists/" + set + "_labels_" + i + ".txt");
		labels = labels(1:end-1);

		% load matrices
		data{i} = loader(filenames, labels, "", length, channels);
	end
end
