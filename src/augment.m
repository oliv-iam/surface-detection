% several options for data augmentation
function aug_train = augment(raw_train, method, frac)
    % source: https://arxiv.org/abs/1706.00527
    % methods: "none", "oversample", "noise", "scale", "magwarp",
    % "timewarp"

    if method ~= "none"
        labels = unique(raw_train.labels);
        counts = groupcounts(raw_train.labels);
        num = round((1+frac) * max(counts));
    end

    % random oversampling
    if method == "oversample"
        toadd = sample(raw_train, labels, num);
        aug_train = [raw_train; toadd];

    % apply gaussian noise
    elseif method == "noise"
        toadd = sample(raw_train, labels, num);

        for i = 1:height(toadd)
            dev = 0.03 * randn;
            seq = toadd.sequences{i};
            noise = dev * randn(size(seq));
            toadd.sequences{i} = seq + noise;
        end

        aug_train = [raw_train; toadd];

    % multiply both channels by scalar
    elseif method == "scale"
        toadd = sample(raw_train, labels, num);

        for i = 1:height(toadd)
            scale = 1 + 0.1 * randn;
            toadd.sequences{i} = toadd.sequences{i} * scale;
        end
        
        aug_train = [raw_train; toadd];
  
    % multiply channels by curve
    elseif method == "magwarp"
        toadd = sample(raw_train, labels, num);
        [~,dims] = size(toadd.sequences{1});

        for i = 1:height(toadd)
            curves = bezier(dims);
            toadd.sequences{i} = toadd.sequences{i} .* curves;
        end

        aug_train = [raw_train; toadd];

    elseif method == "timewarp"
        toadd = sample(raw_train, labels, num);
		for i = 1:height(toadd)
			toadd.sequences{i} = timewarp(toadd.sequences{i});
		end
		aug_train = [raw_train; toadd];
    
	% rotation: not yet implemented
	elseif method == "rotate"
            aug_train = rotate(pivot_train, num);

    % identity: no augmentation
    else
            aug_train = raw_train;
    end
end

% random sample
function toadd = sample(raw_train, labels, num)
    % for each class, sample up to num
    for i = 1:5
        matches = find(raw_train.labels == labels(i));
        idx1 = randi(length(matches), num-length(matches), 1);
        idx2 = matches(idx1);
        if i == 1
            toadd = raw_train(idx2, :);
        else
            toadd = [toadd; raw_train(idx2, :)];
        end
    end
end

% rotate channels
function rotate()
end

% generate random curves
function curves = bezier(dims)
    % default parameters:
    sigma = 0.2;
    npts = 4;

    % generate control points, time steps
    cpts = 1 + sigma * randn(npts, dims);
    t = linspace(0, 1, 50)';

    % compute bezier curve for each dimension
    curves = zeros(50, dims);
    for i = 1:dims
        n = npts - 1;
        curve = zeros(50, 1);
        for j = 0:n
            curve = curve + (cpts(j+1, i) * nchoosek(n, j)) * (((1-t).^(n-j)) .* t.^j);
        end
        curves(:, i) = curve;
    end
end

% distort time intervals for sample
function warped = timewarp(sequence)
	[time,dim] = size(sequence);
	curves = bezier(dim);
	ttcum = cumsum(curves, 1);
	tscale = (time-1) ./ ttcum(end, :);
	ttcum = ttcum .* tscale;

	xrange = (0:(time-1))';
	warped = zeros(size(sequence));
	for i = 1:dim
		warped(:, i) = interp1(ttcum(:, i), sequence(:, i), xrange, 'pchip', 'extrap');
	end
end

% variational autoencoder

% generative adversarial network
