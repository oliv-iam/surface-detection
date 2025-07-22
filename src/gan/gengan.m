function sequences = gengan(netg, n, inmin, inmax)
	% generate sequences
	latentinputs = 100;
	znew = randn(latentinputs, n, 'single');
	znew = dlarray(znew, 'CB');
	
	xgenerated = predict(netg, znew);
	
	% reformat output to 50x2 inside cell array
	X = extractdata(xgenerated);

	% rescale back from [-1, 1]
	X = rescale(X, inmin, inmax, InputMin=-1, InputMax=1);

	% numobs = size(X, 2);
	sequences = cell(n, 1);
	for i = 1:n
		sequence = squeeze(X(:,i,:)); % CBT -> TC
		sequences{i} = sequence.';
	end
end
