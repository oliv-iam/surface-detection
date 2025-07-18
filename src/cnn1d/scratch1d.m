function net = scratch1d(dataset_train)
	layers = [
		sequenceInputLayer(2, Normalization="none", MinLength=50)
		
		convolution1dLayer(3, 32, Padding='same')
		batchNormalizationLayer
		reluLayer
		convolution1dLayer(3, 32, Padding='same')
		batchNormalizationLayer
		reluLayer
		maxPooling1dLayer(2, Stride=2)

		convolution1dLayer(3, 64, Padding='same')
		batchNormalizationLayer
		reluLayer
		dropoutLayer(0.4)
		
		globalAveragePooling1dLayer
		fullyConnectedLayer(64)
		reluLayer
		dropoutLayer(0.5)

		fullyConnectedLayer(5)
		softmaxLayer];

	options = trainingOptions('adam', ...
		InitialLearnRate=1e-3, ...
        MaxEpochs=100, ...
        MiniBatchSize=32, ...
        Shuffle='every-epoch', ...
        LearnRateSchedule="piecewise", ...
        LearnRateDropPeriod=25, ...
        LearnRateDropFactor=0.5, ...
		L2Regularization = 0.0005, ...
        Verbose=false);

	net = trainnet(dataset_train.sequences, dataset_train.labels, layers, 'crossentropy', options);
