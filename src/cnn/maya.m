function net = maya(num_channels, dataset_train)
	layers = [
		sequenceInputLayer(num_channels)

		convolution1dLayer(3, 128, Stride=1, Padding=1, WeightsInitializer="glorot", BiasInitializer="zeros")
		reluLayer

		convolution1dLayer(3, 384, Stride=1, Padding=1)
		batchNormalizationLayer(ScaleInitializer="ones", OffsetInitializer="zeros")

        globalAveragePooling1dLayer
     
		fullyConnectedLayer(5)
		softmaxLayer
		];

	options = trainingOptions('adam', ...
		MiniBatchSize=10, ...
		MaxEpochs=30, ...
		InitialLearnRate=1e-5, ...
		Verbose=false);

	net = trainnet(dataset_train.sequences, dataset_train.labels, layers, 'crossentropy', options);
end
