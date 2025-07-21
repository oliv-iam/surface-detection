% sequences as cell array -> training generator and discriminator nets
function netg = traingan(sequences)
	% training options
	latentinputs = 100 % from generator function
	epochs = 500;
	batchsize = 128;
	learnrate = 0.0002;
	gradientdecayfactor = 0.5;
	squaredgradientdecayfactor = 0.999;
	flipprob = 0.35;
	validationfrequency = 100;
	
	% format data for training
	ads = arrayDatastore(sequences, IterationDimension=1);
	mbq = minibatchqueue(ads, ...
		MiniBatchSize=batchsize, ...
		PartialMiniBatch='discard', ...
		MiniBatchFcn=@preprocessminibatch, ...
		MiniBatchFormat='CTB');

	% generator and discriminator structure
	netg = generator();
	netd = discriminator();

	% initialize parameters for adam optimization
	trailingavgg = [];
	trailingavgsqg = [];
	trailingavg = [];
	trailingavgsqd = [];

	% holdouts to monitor progress
	% numvalims = 25;
	% zvalidation = randn(latentinputs, numvalims, 'single');
	% zvalidation = dlarray(zvalidation, 'CB');

	% initialize trainingProgressMonitor object
	numobstrain = length(sequences);
	numiterationsperepoch = floor(numobstrain / batchsize);
	numiterations = epochs * numiterationsperepochs;
	monitor = trainingProgressMonitor( ...
		Metrics=['GeneratorScore', 'DiscriminatorScore'], ...
		Info=['Epoch', 'Iteration'];
		XLabel='Iteration');
	groupSubPlot(monitor, Score=['GeneratorScore', 'DiscriminatorScore'])

	% training loop
	epoch = 0;
	interation = 0;
	
	while epoch < epochs && ~monitor.Stop
		epoch = epoch + 1;
		
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
			[~,~,gradsg,gradsd,stated,scoreg,scored] = dlfeval(@modelloss, ...
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

% define generator network
function netg = generator()
    filtersize = 5;
    filters = 64;
    latentinputs = 100;
    projectionsize = [6 1 128];

    layersg = [
        % feature -> projection
        featureInputLayer(latentinputs, Normalization="none")
        fullyConnectedLayer(prod(projectionsize))
        functionLayer(@(X) reshape(X, projectionSize), Formattable=true)

        % upscale: projection -> 50x2
        transposedConv1dLayer(filtersize, 4*filters, Stride=2, Cropping='same')
        batchNormalizationLayer
        reluLayer
        transposedConv1dLayer(filtersize, 2*filters, Stride=2, Cropping='same')
        batchNormalizationLayer
        reluLayer
        transposedConv1dLayer(filtersize, filters, Stride=2, Cropping='same')
        batchNormalizationLayer
        reluLayer
        transposedConv1dLayer(3, 2, Stride=1, Cropping='same')
        sigmoidLayer]; % or tanh

    netg = dlnetwork(layersg);
end

% define discrimator network
function netd = discriminator()
    dprob = 0.5;
    filters = 64;
    scale = 0.2;

    inputsize = 2;
    filtersize = 5;

    layersd = [
        sequenceInputLayer(inputsize)
        dropoutLayer(dprob)
        convolution1dLayer(filtersize, filters, Stride=2, Padding='same')
        leakyReluLayer(scale)
        convolution1dLayer(filtersize, 2*filters, Stride=2, Padding='same')
        batchNormalizationLayer
        leakyReluLayer(scale)
        convolution1dLayer(filtersize, 4*filters, Stride=2, Padding='same')
        batchNormalizationLayer
        leakyReluLayer(scale)
        convolution1dLayer(filtersize, 8*filters, Stride=2, Padding='same')
        batchNormalizationLayer
        leakyReluLayer(scale)
        convolution1dLayer(4, 1)
        sigmoidLayer];

    netd = dlnetwork(layersd);
end

% define model loss functions
function [lossg,lossd,gradsg,gradsd,stateg,scoreg,scored] = modelloss(netg,netd,x,z,flipprob)
	% calculate predictions for real data with discriminator
	yreal = forward(netd,x);

	% calculate predictions for generator data with discriminator
	[xgenerated, stateg] = forward(netg,z);
	ygenerated = forward(netd, xgenerated);

	% calculate score of discriminator
	scored = (mean(yreal) + mean(1-ygenerated)) / 2;

	% calculate score of generator
	scoreg = mean(ygenerated);

	% randomly flip labels of real images
	numobs = size(yreal,4);
	idx = rand(1, numobs) < flipprob;
	yreal(:,:,:,idx) = 1 - yreal(:,:,:,idx);

	% calculate GAN loss
	[lossg, lossd] = ganloss(yreal, ygenerated);

	% for each network, calculate gradients wrt loss
	gradsg = dlgradient(lossg, netg.Learnables, RetainData=true);
	gradsd = dlgradient(lossd, netd.Learnables);
end

function [lossg, lossd] = ganloss(yreal, ygenerated) 
	% calculate loss for discriminator network
	lossd = -mean(log(yreal)) - mean(log(1-ygenerated));

	% calculate loss for generator network
	lossg = -mean(log(ygenerated));
end

function X = preprocessminibatch(data)
	% permute matrices to correct format
	for i = 1:length(data)
		data{i} = permute(data{i}, [2 1]);
	end

	% concatenate mini-batch
	X = cat(3, data{:});

	% determine min and max values
	inmin = min(X(:));
	inmax = max(X(:));

	% rescale images to range [-1 1]
	X = rescale(X, -1, 1, InputMin=inmin, InputMax=inmax);
end
