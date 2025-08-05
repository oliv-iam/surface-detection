% several options for data augmentation
function aug_train = augment(raw_train, method, full, frac)
    % source: https://arxiv.org/abs/1706.00527
    % methods: "none", "oversample", "noise", "scale", "magwarp",
    % "timewarp", "cnorm", "unorm", "gan"

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
		[~,dims] = size(raw_train.sequences{1});
		if full
			aug_train = raw_train;
			curves = bezier(dims, "gaussian");
			for i = 1:height(raw_train)
				aug_train.sequences{i} = raw_train.sequences{i} .* curves;
			end
		else
        	toadd = sample(raw_train, labels, num);
        	for i = 1:height(toadd)
            	curves = bezier(dims, "match"); % 'rand', 'match'
            	toadd.sequences{i} = toadd.sequences{i} .* curves;
        	end
        	aug_train = [raw_train; toadd];
		end

    elseif method == "timewarp"
		if full
			aug_train = raw_train;
			for i = 1:height(raw_train)
				aug_train.sequences{i} = timewarp(raw_train.sequences{i}, "gaussian");
			end
		else
        	toadd = sample(raw_train, labels, num);
			for i = 1:height(toadd)
				toadd.sequences{i} = timewarp(toadd.sequences{i}, "rand");
			end
			aug_train = [raw_train; toadd];
		end

	% normalization methods
	elseif method == "cnorm"
		sequences = cell(height(raw_train), 1);
		for i = 1:height(raw_train)
			sequences{i} = normalize(raw_train.sequences{i});
		end
		aug_train = table(sequences, raw_train.labels, raw_train.users, ...
			VariableNames={'sequences', 'labels', 'users'});
	
	elseif method == "unorm"
		% assume raw_train contains all of one user's samples
		aug_sequences = cell(height(raw_train), 1);
		[mns, stds, w] = meanstd(raw_train.sequences);
		for j = 1:height(raw_train)
			mtx = raw_train.sequences{j};
			for k = 1:w
				mtx(:,k) = mtx(:,k)-mns(k) ./ stds(k);
			end
			aug_sequences{j} = mtx;
		end
		aug_train = table(aug_sequences, raw_train.labels, raw_train.users, ...
			VariableNames={'sequences', 'labels', 'users'});
    
	% generative adversarial network
	elseif method == "gan"
		for i = 1:5
			% train GAN
			matches = find(raw_train.labels == labels(i));
			[netg, inmin, inmax] = traingan(raw_train.sequences(matches));
			
			% generate new sequences
			n = num - length(matches);
			new_sequences = gengan(netg, n, inmin, inmax);
			new_labels = repmat(raw_train.labels(matches(1)), n, 1);
			new_users = repmat(raw_train.users(1), n, 1); 

			% add to table
			aug_app = table(new_sequences, new_labels, new_users, ...
				VariableNames={'sequences', 'labels', 'users'});
			if i == 1
				toadd = aug_app;
			else
				toadd = [toadd; aug_app];
			end
		end
		aug_train = [raw_train; toadd];

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

% mean and standard deviation over samples
function [mns, stds, w] = meanstd(sequences)
	[h,w] = size(sequences{1});

	% copy matrices into one
	bigmtx = zeros(h * length(sequences), w); 
	for i = 0:(length(sequences)-1)
		rstart = (i*h) + 1;
		rend = (i+1) * h;
		bigmtx(rstart:rend, 1:w) = sequences{i+1};
	end

	% get mean and standard deviation of each column
	mns = mean(bigmtx, 1);
	stds = std(bigmtx, 1);
end

% generate random curves
function curves = bezier(dims, style)
	% style: "rand", "match", "gaussian"
    % default parameters:
    sigma = 0.2;
    npts = 4;

    % generate control points, time steps
    t = linspace(0, 1, 50)';

    % compute bezier curve for each dimension
	if style == "rand"
		cpts = 1 + sigma * randn(npts, dims);	
    	curves = zeros(50, dims);
    	for i = 1:dims
        	n = npts - 1;
        	curve = zeros(50, 1);
        	for j = 0:n
            	curve = curve + (cpts(j+1, i) * nchoosek(n, j)) * (((1-t).^(n-j)) .* t.^j);
        	end
        	curves(:, i) = curve;
    	end
	elseif style == "match"
		cpts = 1 + sigma * randn(npts, 1);
		n = npts - 1;
		curve = zeros(50, 1);
		for j = 0:n
			curve = curve + (cpts(j+1) * nchoosek(n, j)) * (((1-t).^(n-j)) .* t.^j);
		end
		curves = repmat(curve, 1, dims);
	else
		x = -24:1:25;
		curve = normpdf(x, 0, 24);
		curve = curve / max(curve);
		curves = repmat(curve', 1, dims);
	end
end

% distort time intervals for sample
function warped = timewarp(sequence, curve)
	[time,dim] = size(sequence);
	curves = bezier(dim, curve);
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
