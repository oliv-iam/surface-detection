% Partition and format dataset for training and evaluation
function [dataset_train, dataset_val, dataset_test] = prepdataset(ratios, tester, set, logname, norm)
    % ratios = [0.8 0.2 0.2]
    % tester = 0 : default, otherwise exclude user from training and validation sets
    % set = "set1", "set2"
    % logname =  "" or name for file for indices
    % norm = "" or "linear", "zscore" 

    dataset_dir = "sequences/" + set;

	if set == "set5" | set == "set6" | set == "set7"
		dataset_dir = "sequences/set1";
	end
    
    filenames = readlines("sequences/" + set + "_filenames.txt");
    filenames = fullfile(dataset_dir, filenames(1 : end-1));
    
    labels = readlines("sequences/" + set + "_labels.txt");
    labels = labels(1 : end-1);

    % split into training, test, validation sets
    classes = cell(1, 5);
    
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
    
	if set == "set8"
		length = 64;
	else
		length = 128;
	end
	if set == "set9"
		channels = 6;
	else
		channels = 2;
	end

    dataset_train = loader(filenames_train, labels_train, norm, length, channels);
    dataset_val = loader(filenames_val, labels_val, norm, length, channels);
    dataset_test = loader(filenames_test, labels_test, norm, length, channels);
end

function output = loader(filenames, labels, norm, length, channels)
    if norm ~= ""
		ranges = { % [amin amax ; gmin gmax]
		    [0.345728371800269 39.7047344635759; 1.9962881523604 555.803931697052],  % U1
		    [1.21581533040363 41.6495339481341; 0.551648140554445 533.261818814418], % U2
		    [1.12687774146127 38.6617047107348; 0.644026375676632 587.904318225094],
			[0.248908572606793 42.5714848846258; 0.902333264482043 569.440359311625],
			[0.822960897141466 37.0213590882006; 0.352105240053744 525.089353825878]
			};

		meanstd = { % [amean astddev ; gmean gstddev]
	    	[12.629859443887135 5.738365620992473; 163.49229325326618 96.74042606392025],
	    	[11.777983949638422 3.977903265327697; 143.41084227513744 89.40506678202725],
	    	[11.95367744554427 4.605674262216766; 136.1571538121075 84.66152113974925],
	    	[12.848753561964747 5.709960951749006; 168.40407116679668 109.24140341174476],
	    	[11.956030376280081 4.810568933834056; 130.58126471037482 87.22253286321497]
	    	};
	end

    datamtx = zeros(length, channels, numel(filenames));
    for i = 1:numel(filenames)
        mtx = readmatrix(filenames(i));
	
		if norm ~= ""
			% user
			ustr = filenames(i).split("_");
			ustr = ustr(end-3).split('r');
			u = str2double(ustr(2));
		
			if norm == "linear"
				% linear normalization by user
				mtx(:,1) = (mtx(:,1)-ranges{u}(1,1)) ./ (ranges{u}(1,2)-ranges{u}(1,1));
				mtx(:,2) = (mtx(:,2)-ranges{u}(2,1)) ./ (ranges{u}(2,2)-ranges{u}(2,1));
			end

			if norm == "zscore"
				% zscore normalization by user
				mtx(:,1) = (mtx(:,1)-meanstd{u}(1,1)) ./ meanstd{u}(1,2);
				mtx(:,2) = (mtx(:,2)-meanstd{u}(2,1)) ./ meanstd{u}(2,2);
			end
		end

		datamtx(:,:,i) = mtx;
    end

    sequences = squeeze(num2cell(datamtx, [1 2]));
    labels = categorical(labels);
    output = table(sequences, labels);
end
