% matlab example lstm
function net = exlstm(num_channels, dataset_train)
    % changes: hidden_units 120 -> 60, added g.a.p

	hidden_units = 60;
	
	layers = [
		sequenceInputLayer(num_channels)
		lstmLayer(hidden_units) % (bilstm performs a bit better)
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
