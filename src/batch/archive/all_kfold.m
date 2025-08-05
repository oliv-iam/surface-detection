% k-fold cross validation, one user per model
function all_kfold(k, data)
	% k: number of folds
	% data: dataset as 5-cell array of data (cell array) and labels (categoricals)
	
	tic	
    data = stacker(data, 2, false, "none"); 
	cv = cvpartition(data.labels, Kfold=k);
	data_train = cell(1,k);
	data_test = cell(1,k);
	for j = 1:k
		data_train{j} = data(cv.training(j), :);
    	data_test{j} = data(cv.test(j), :);
	end
	fprintf("Data preparation complete\n");
	toc	

	% iterate over splits
	tic
	kacc = zeros(k, 1);
    % parfor (j = 1:k) 
    for j = 1:k
		% train model
		net = scratch(data_train{j});
		
		% check accuracy on test set
		tmp = neteval(net, data_train{j}, "image", ...
				"logs/scratch/scratch_all_trainpreds.txt", j==0);
		kacc(j) = neteval(net, data_test{j}, "image", ...
				"logs/scratch/scratch_all_testpreds.txt", j==0);
    end
    toc

    % write to log file
    f = fopen("logs/scratch/scratch_all_acc.txt", "a+");
    fprintf(f, "%f,", kacc);
    fprintf(f, "\n");

	% average accuracy across iterations
	acc = mean(kacc);
	fprintf("Average accuracy: %.4f\n", acc);
end
