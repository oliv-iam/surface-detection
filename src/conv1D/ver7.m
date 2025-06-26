% maya's self-attention model
function [net, info] = ver7(dataset_train, dataset_val, num_channels);
	layers = [
		sequenceInputLayer(num_channels)

		convolution1dLayer(3, 16, Stride=1, Padding=4)
		reluLayer

		convolution1dLayer(3, 32, Stride=1, Padding=1)
		batchNormalizationLayer
		reluLayer

		convolution1dLayer(3, 48, Stride=1, Padding=1)
		batchNormalizationLayer
		reluLayer

		selfAttentionLayer(8, 48)
		reluLayer

		globalAveragePooling1dLayer

		fullyConnectedLayer(64)
		reluLayer

		fullyConnectedLayer(5)
		softmaxLayer
		];

	options = trainingOptions('adam', ...
		InitialLearnRate=0.001, ...
		MaxEpochs=60, ...
		MiniBatchSize=16, ...
		Shuffle='every-epoch', ...
		L2Regularization=1e-4, ...
		LearnRateSchedule='piecewise', ...
		LearnRateDropPeriod=15, ...
		LearnRateDropFactor=0.5, ...
		ValidationData={dataset_val.sequences, dataset_val.labels}, ...
		ValidationPatience=20, ...
		Verbose=true, ...
		Plots='training-progress', ...
		Metrics='accuracy');

	[net, info] = trainnet(dataset_train.sequences, dataset_train.labels, layers, 'crossentropy', options);
end
