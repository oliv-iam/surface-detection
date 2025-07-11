% k-fold cross validation, one user per model
function kfold(k, data, aug, augsize)
	% k: number of folds
	% data: dataset as 5-cell array of data (cell array) and labels (categoricals)
	[~, ch] = size(data{1}.sequences{1});	
	acc = zeros(1, 5);	
    % parpool("cpu-q", k);

	% iterate over users
	for i = 1:5 
		fprintf("User %d:\n", i);
	
		% split user's data into k pieces, augment training data
		cv = cvpartition(data{i}.labels, Kfold=k);
        data_train = cell(1, k);
        data_test = cell(1, k);
        for j = 1:k
				data_train{j} = augment(data{i}(cv.training(j), :), aug, augsize);
                data_test{j} = data{i}(cv.test(j), :);
        end

		% iterate over splits
		tic
		kacc = zeros(k, 1);
        parfor (j = 1:k) 
		% for j = 1:k
			% train model
			net = evalcnn("sequence", data_train{j});
		
			% check accuracy on test set
			kacc(j) = neteval(net, data_test{j}, "");
        end
        toc

        % write to log file
        f = fopen("logs/kfold/augment/" + aug + "_" + augsize + ".txt", "a+");
        fprintf(f, "%f,", kacc);
        fprintf(f, "\n");

		% average accuracy across iterations
		acc(i) = mean(kacc);
		fprintf("Average accuracy for User %d: %.4f\n", i, acc(i));
	end

	% average accuracy across iterations
	fprintf("Final accuracy across users: %.4f\n", mean(acc));
end
