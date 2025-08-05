function accuracy = neteval(net, dataset, input, filename, headers)
	xtestcell = dataset.sequences;
    ytest = dataset.labels;
    numsamples = numel(xtestcell);
	
	if input == "image"
		[h, w] = size(xtestcell{1});
		xtestarr = zeros(h, w, 1, numsamples, 'single');
		for i = 1:numsamples
			xtestarr(:, :, 1, i) = single(xtestcell{i});
		end
		dlxtest = dlarray(xtestarr, 'SSCB');
	else
		[seqlen, numchannels] = size(dataset.sequences{1});
		xtestarr = zeros(numchannels, numsamples, seqlen, 'single');
		for i = 1:numsamples
			seq = xtestcell{i};
			xtestarr(:, i, :) = permute(single(seq), [2 3 1]);
		end
		dlxtest = dlarray(xtestarr, 'CBT');
    end

    dlypred = predict(net, dlxtest);
    [~, idx] = max(extractdata(dlypred), [], 1);

    classes = categories(ytest);
    ypred = categorical(classes(idx), classes);
    
    if filename ~= ""
    	% save to file  
    	flog = table(ytest, ypred, 'VariableNames', ["True", "Predicted"]);
    	writetable(flog, filename, WriteMode='append', WriteVariableNames=headers);
    end

    accuracy = mean(ypred == ytest);
end  
