% k-fold cross validation, one user per model
function kfold(k, data, name)
	% k: number of folds
	% data: dataset as 5-cell array of data (cell array) and labels (categoricals)
	% [~, ch] = size(data{1}.sequences{1});	
	acc = zeros(1, 5);	

	% iterate over users
	for i = 1:5 
		fprintf("User %d:\n", i);
		
		% split user's data into k pieces, augment training data
		tic
        data{i} = stacker(data{i}, 2, false, "none"); 
		cv = cvpartition(data{i}.labels, Kfold=k);
        data_train = cell(1, k);
        data_test = cell(1, k);
		for j = 1:k
			data_train{j} = data{i}(cv.training(j), :);
            data_test{j} = data{i}(cv.test(j), :);
        end
		fprintf("Data preparation complete\n");
		toc

		% iterate over splits
		tic
		kacc = zeros(k, 1);
        for j = 1:k
			% train model
			net = maya2d(data_train{j});
		
			% check accuracy on test set
			tmp = neteval(net, data_train{j}, "image", ...
				"logs/scratch/maya2d_trainpreds_" + name + ".txt", j==0);
			kacc(j) = neteval(net, data_test{j}, "image", ...
				"logs/scratch/maya2d_testpreds_" + name + ".txt", j==0);
        end
        toc

        % write to log file
        f = fopen("logs/scratch/maya2d_acc_" + name + ".txt", "a+");
        fprintf(f, "%f,", kacc);
        fprintf(f, "\n");

		% average accuracy across iterations
		acc(i) = mean(kacc);
		fprintf("Average accuracy for User %d: %.4f\n", i, acc(i));
	end

	% average accuracy across iterations
	fprintf("Final accuracy across users: %.4f\n", mean(acc));
end
