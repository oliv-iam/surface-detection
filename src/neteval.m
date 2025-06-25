function accuracy = neteval(net, dataset, filename)
    xtestcell = dataset.sequences;
    ytest = dataset.labels;   
    numsamples = numel(xtestcell);
    xtestarr = zeros(2, numsamples, 128, 'single');
    for i = 1:numsamples
        seq = xtestcell{i};
	xtestarr(:, i, :) = permute(single(seq), [2 3 1]);
    end

    dlxtest = dlarray(xtestarr, 'CBT');
    dlypred = predict(net, dlxtest);

    [~, idx] = max(extractdata(dlypred), [], 1);

    classes = categories(ytest);
    ypred = categorical(classes(idx), classes);
    
    if filename ~= ""
    	% save to file  
    	flog = table(ytest, ypred, 'VariableNames', ["True", "Predicted"]);
    	writetable(flog, filename);
    end

    accuracy = mean(ypred == ytest);
end  
