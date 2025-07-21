function sequences = gengan(netg, n)
	% generate sequences
	latentinputs = 100;
	znew = randn(latentinputs, n, 'single');
	znew = dlarray(znew, 'CB');
	
	xgenerated = predict(netg, znew);
	
	% reformat output to 50x2 inside cell array
	X = extractdata(xgenerated);
	numobs = size(X, 3);
	sequences = cell(numobs, 1);
	for i = 1:numobs
		sequence = permute(X(:,:,i), [2 1]);
		sequences{i} = sequence;
	end
end
