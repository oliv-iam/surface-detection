function net = simple(dataset_train)
    [h, w] = size(dataset_train.sequences{1});

	% reformat training data
	n = height(dataset_train);
    train_image = zeros(h, w, 1, n);
    for i = 1:n
        train_image(:, :, 1, i) = dataset_train.sequences{i};
    end	

	% network definition and training
    layers = [
        imageInputLayer([h w 1], Normalization="none")
		
		convolution2dLayer(3, 32, Padding='same')
		batchNormalizationLayer
		reluLayer
		convolution2dLayer(3, 32, Padding='same')
		batchNormalizationLayer
		reluLayer
		maxPooling2dLayer(2, Stride=2)

		convolution2dLayer(3, 64, Padding='same')
		batchNormalizationLayer
		reluLayer
		dropoutLayer(0.4)

		% globalAveragePooling2dLayer
		fullyConnectedLayer(64);
		reluLayer
		dropoutLayer(0.5)

		fullyConnectedLayer(5);
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
			
	net = trainnet(train_image, dataset_train.labels, layers, 'crossentropy', options);
