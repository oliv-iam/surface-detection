function net = ver8(num_channels, dataset_train)
	hidden_units = 120;
	
	layers = [
		sequenceInputLayer(num_channels)
		bilstmLayer(hidden_units)
		globalAveragePooling1dLayer
		fullyConnectedLayer(5)
		softmaxLayer];

	options = trainingOptions('adam', ...
		MaxEpochs=200, ...
		InitialLearnRate=0.002, ...
		GradientThreshold=1, ...
		Shuffle='every-epoch', ...
		Metrics='accuracy', ...
		Verbose=false);

	net = trainnet(dataset_train.sequences, dataset_train.labels, layers, 'crossentropy', options);
end
