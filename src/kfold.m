% k-fold cross validation, one user per model
function kfold(k, data)
	% k: number of folds
	% data: dataset as 5-cell array of data (cell array) and labels (categoricals)
	
	acc = zeros(1, 5);	

	% iterate over users
	for i = 1:5 
		fprintf("User %d:\n", i);
	
		% split user's data into k pieces
		cv = cvpartition(data{i}.labels, 'KFold', k);
				
		% iterate over splits
		tic
		kacc = zeros(1, k);
		% parfor (j = 1:k, k) 
		for j = 1:k
			% train model
			net = exlstm(2, data{i}(cv.training(j), :));
		
			% check accuracy on test set
			kacc(j) = neteval(net, 128, 2, data{i}(cv.test(j), :), "");
			% kacc(j) = neteval(net, 128, 2, data{i}(cv.training(j), :), "");
			fprintf("%.4f\n", kacc(j));
		end
		toc

		% average accuracy across iterations
		acc(i) = mean(kacc);
		fprintf("Average accuracy for User %d: %.4f\n", i, acc(i));
	end

	% average accuracy across iterations
	fprintf("Final accuracy across users: %.4f\n", mean(acc));
end
