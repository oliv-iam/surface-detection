function stacked = stacker(raw, n, rot, perm)
    stacked = raw;
    for i = 1:height(raw)
		% stack
		stacki = repmat(raw.sequences{i}, 1, n);
		
		% permute
		if string(perm) ~= "none"
			if string(perm) == "rand"
				stacki = cpermute(stacki, randperm(n*2));
			else		
				stacki = cpermute(stacki, perm);
			end
		end

		% rotate
		if rot
			stacki = transpose(stacki);
		end
		stacked.sequences{i} = stacki;
    end
end

function permuted = cpermute(raw, perm)
	[h, w] = size(raw);
	permuted = zeros(h, w);
	for i = 1:w
		permuted(:, i) = raw(:, perm(i));
	end
end
