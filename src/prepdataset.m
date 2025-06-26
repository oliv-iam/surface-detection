% Partition and format dataset for training and evaluation
function [dataset_train, dataset_val, dataset_test] = prepdataset(tester, set, logname)
    % tester = 0 : default, otherwise exclude user from training and validation sets

    dataset_dir = "sequences/" + set;
    
    filenames = readlines("sequences/" + set + "_filenames.txt");
    filenames = fullfile(dataset_dir, filenames(1 : end-1));
    
    labels = readlines("sequences/" + set + "_labels.txt");
    labels = labels(1 : end-1);

    % split into training, test, validation sets
    classes = cell(1, 5);
    ratios = [0.8 0.1 0.1];
    
    % tester != 0: preserve one user for testing
    cls = uclasses(set);
    for u = 1:5 % iterate over users
	    if u ~= tester
		    ucls = cls{u};
		    for l = 1:5
			    classes{l} = [classes{l} ; ucls{l}];
		    end
	    end
    end
    if tester ~= 0
	    ratios = [0.9 0.1 0];
    end
  
    indices = partition(classes, ratios);
    
    if tester ~= 0
        for i = 1:5
	        indices{3} = [indices{3} ; cls{tester}{i}];
        end
    end

    if logname ~= ""
	    % log indices
	    writematrix(indices{1}, "logs/dataset-info/" + logname + "_train.txt");
	    writematrix(indices{2}, "logs/dataset-info/" + logname + "_val.txt");
	    writematrix(indices{3}, "logs/dataset-info/" + logname + "_test.txt");
    end
    
    % load data and format for training
    filenames_train = filenames(indices{1});
    labels_train = labels(indices{1});
    filenames_val = filenames(indices{2});
    labels_val = labels(indices{2});
    filenames_test = filenames(indices{3});
    labels_test = labels(indices{3});
    
    dataset_train = loader(filenames_train, labels_train);
    dataset_val = loader(filenames_val, labels_val);
    dataset_test = loader(filenames_test, labels_test);
end

function output = loader(filenames, labels)
    datamtx = zeros(128, 2, numel(filenames));
    for i = 1:numel(filenames)
        datamtx(:,:,i) = readmatrix(filenames(i));
    end

    sequences = squeeze(num2cell(datamtx, [1 2]));
    labels = categorical(labels);
    output = table(sequences, labels);
end
