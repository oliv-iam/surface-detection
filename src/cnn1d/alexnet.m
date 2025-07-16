% mock AlexNet architecture (smaller, added batchNorm)
function net = alexnet(num_channels, dataset_train)
        layers = [
            sequenceInputLayer(num_channels, MinLength=50)

		    convolution1dLayer(11, 64, Stride=4) % original: 96 filters
		    batchNormalizationLayer
		    reluLayer
		    maxPooling1dLayer(3, Stride=2)
    
		    convolution1dLayer(5, 128, Padding=2, Stride=1) % original: 256
		    batchNormalizationLayer
		    reluLayer
		    maxPooling1dLayer(3, Stride=2)
    
		    convolution1dLayer(3, 256, Padding=1, Stride=1) % original: 384
		    batchNormalizationLayer
		    reluLayer
    
		    convolution1dLayer(3, 256, Padding=1, Stride=1) % original: 384
		    batchNormalizationLayer
		    reluLayer
    
		    convolution1dLayer(3, 128, Padding=1, Stride=1) % original: 256
		    batchNormalizationLayer
		    reluLayer
		    maxPooling1dLayer(3, Padding="same", Stride=2)

            globalAveragePooling1dLayer % original: flatten

		    fullyConnectedLayer(512) % original: 4096
		    reluLayer
		    dropoutLayer(0.3) % original: 0.5
    
		    fullyConnectedLayer(128) % original: 4096
		    reluLayer
		    dropoutLayer(0.3) % original: 0.5
    
		    fullyConnectedLayer(5)
		    softmaxLayer
            ];

        % training options
        options = trainingOptions('adam', ...
                InitialLearnRate=0.0005, ...
                MaxEpochs=20, ...
                MiniBatchSize=16, ...
                Shuffle='every-epoch', ...
                LearnRateSchedule="piecewise", ...
                LearnRateDropPeriod=10, ...
                LearnRateDropFactor=0.5, ...
		        L2Regularization=0.0005, ...
                Verbose=false);

        % train model
        net = trainnet(dataset_train.sequences, dataset_train.labels, layers, 'crossentropy', options);
end
