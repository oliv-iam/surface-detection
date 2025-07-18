% k-fold cross validation, one user per model
function kfold(k, data, name)
	% k: number of folds
	% data: dataset as 5-cell array of data (cell array) and labels (categoricals)
	% [~, ch] = size(data{1}.sequences{1});	
	acc = zeros(1, 5);	

	% iterate over users
	for i = 1:5 
		fprintf("User %d:\n", i);

        % data{i} = stacker(data{i}, 2, true, "none"); 
		% data{i} = augment(data{i}, "magwarp", 0);	
		
		% split user's data into k pieces, augment training data
		cv = cvpartition(data{i}.labels, Kfold=k);
        data_train = cell(1, k);
        data_test = cell(1, k);
        for j = 1:k
				% data_train{j} = augment(data{i}(cv.training(j), :), "magwarp", 0.8);
				data_train{j} = data{i}(cv.training(j), :);
                data_test{j} = data{i}(cv.test(j), :);
        end

		% iterate over splits
		tic
		kacc = zeros(k, 1);
        parfor (j = 1:k) 
        % for j = 1:k
			% train model
			net = scratch1d(data_train{j});
		
			% check accuracy on test set
			tmp = neteval(net, data_train{j}, "sequence", "logs/kfold/scratch/scratch_stacks_trainpreds" + i + "_" + name + ".txt", j==0);
			kacc(j) = neteval(net, data_test{j}, "sequence", "logs/kfold/scratch/scratch_stacks_testpreds" + i + "_" + name + ".txt", j==0);
        end
        toc

        % write to log file
        f = fopen("logs/kfold/scratch/scratch_stacks_acc_" + name + ".txt", "a+");
        fprintf(f, "%f,", kacc);
        fprintf(f, "\n");

		% average accuracy across iterations
		acc(i) = mean(kacc);
		fprintf("Average accuracy for User %d: %.4f\n", i, acc(i));
	end

	% average accuracy across iterations
	fprintf("Final accuracy across users: %.4f\n", mean(acc));
end
