% sequences as cell array -> training generator and discriminator nets
function [netg, inmin, inmax] = traingan(sequences)
	% training options
	latentinputs = 100; % from generator function
	epochs = 500;
	batchsize = 128;
	learnrate = 0.0002;
	gradientdecayfactor = 0.5;
	squaredgradientdecayfactor = 0.999;
	flipprob = 0.35;
	
	% format data for training
    fullmtx = cell2mat(sequences);
    inmin = min(fullmtx(:));
    inmax = max(fullmtx(:));
	ads = arrayDatastore(sequences, IterationDimension=1);
	mbq = minibatchqueue(ads, ...
		MiniBatchSize=batchsize, ...
		PartialMiniBatch='discard', ...
		MiniBatchFcn=@(data) preprocessminibatch(data, inmin, inmax), ...
		MiniBatchFormat='CBT');

	% generator and discriminator structure
	netg = generator();
	netd = discriminator();

	% initialize parameters for adam optimization
	trailingavgg = [];
	trailingavgsqg = [];
	trailingavg = [];
	trailingavgsqd = [];

	% initialize trainingProgressMonitor object
	numobstrain = length(sequences);
	numiterationsperepoch = floor(numobstrain / batchsize);
	numiterations = epochs * numiterationsperepoch;
	monitor = trainingProgressMonitor( ...
		Metrics=["GeneratorScore", "DiscriminatorScore"], ...
		Info=["Epoch", "Iteration"], ...
		XLabel="Iteration");
	groupSubPlot(monitor, Score=["GeneratorScore", "DiscriminatorScore"])

	% training loop
	epoch = 0;
	iteration = 0;
	
	while epoch < epochs && ~monitor.Stop
		epoch = epoch + 1;
		if mod(epoch, 50) == 0
			fprintf("GAN Epoch %d\n", epoch);
		end
		
		% reset and shuffle datastore
		shuffle(mbq);

		% loop over mini-batches
		while hasdata(mbq) && ~monitor.Stop
			iteration = iteration + 1;
			X = next(mbq);

			% generate latent inputs for generator, convert to dlarray
			Z = randn(latentinputs, batchsize, 'single');
			Z = dlarray(Z, 'CB');

			% evaluate gradients of loss
			[~,~,gradsg,gradsd,stateg,scoreg,scored] = dlfeval(@modelloss, ...
				netg,netd,X,Z,flipprob);
			netg.State = stateg;

			% update discriminator, generator network parameters
			[netd,trailingavg,trailingavgsqd] = adamupdate(netd, gradsd, ...
				trailingavg, trailingavgsqd, iteration, ...
				learnrate, gradientdecayfactor, squaredgradientdecayfactor);
			[netg,trailingavgg,trailingavgsqg] = adamupdate(netg, gradsg, ...
				trailingavgg, trailingavgsqg, iteration, ...
				learnrate, gradientdecayfactor, squaredgradientdecayfactor);

			% update training progress monitor
			recordMetrics(monitor, iteration, ...
				GeneratorScore=scoreg, ...
				DiscriminatorScore=scored);
			updateInfo(monitor, Epoch=epoch, Iteration=iteration);
			monitor.Progress = 100*iteration/numiterations;
		end
	end
end

function X = preprocessminibatch(data, inmin, inmax)
	% reformat to CBT
	tmp = data{1};
	[t, c] = size(tmp{1});
	b = length(data);
	X = zeros(c, b, t);
	for i = 1:b
		tmp = data{i};
		X(:,i,:) = permute(tmp{1}, [2 3 1]);
	end

	% rescale images to range [-1, 1]
	X = rescale(X, -1, 1, InputMin=inmin, InputMax=inmax);
end
