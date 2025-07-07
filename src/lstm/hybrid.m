function net = hybrid(num_channels, dataset_train)
	layers = [
		sequenceInputLayer(num_channels)
		
		convolution1dLayer(3, 64, Padding='same') 
		batchNormalizationLayer
		reluLayer

		bilstmLayer(60, OutputMode='last') 
		dropoutLayer(0.5)

		fullyConnectedLayer(128)
		reluLayer

		fullyConnectedLayer(5)
    	softmaxLayer];

	options = trainingOptions('adam', ...
        MaxEpochs=200, ...
        InitialLearnRate=0.002, ...
        GradientThreshold=1, ...
        Shuffle='every-epoch', ...
		LearnRateSchedule='piecewise', ...
		LearnRateDropPeriod=50, ...
		LearnRateDropFactor=0.5, ...
        Verbose=false);

	net = trainnet(dataset_train.sequences, dataset_train.labels, layers, 'crossentropy', options);
end
