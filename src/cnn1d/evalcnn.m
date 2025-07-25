function net = evalcnn(input, dataset_train)
	if input == "image"
		layers = [
			imageInputLayer([50 6 1], Normalization="none")
			convolution2dLayer(3, 32, Stride=1, Padding=0)
			batchNormalizationLayer
			reluLayer
			maxPooling2dLayer(2, Stride=1, Padding=0)
			fullyConnectedLayer(5)
			softmaxLayer];
	else
		layers = [
			sequenceInputLayer(6, MinLength=50)
			convolution1dLayer(3, 32, Stride=1, Padding=0)
			batchNormalizationLayer
			reluLayer
			globalMaxPooling1dLayer % had to switch to global
			fullyConnectedLayer(5)
			softmaxLayer];
	end

	options = trainingOptions("adam", ...
		InitialLearnRate=1e-3, ...
		MaxEpochs=60, ...
		MiniBatchSize=32, ...
		Shuffle="every-epoch", ...
		Verbose=false);

    if input == "image"
        n = height(dataset_train);
        dataset_image = zeros(50, 6, 1, n);
        for i = 1:n
            dataset_image(:, :, 1, i) = dataset_train.sequences{i};
        end
        net = trainnet(dataset_image, dataset_train.labels, layers, "crossentropy", options);
    else
        net = trainnet(dataset_train.sequences, dataset_train.labels, layers, "crossentropy", options);
    end
end
