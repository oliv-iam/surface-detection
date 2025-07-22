% define generator network
function netg = generator()
    filtersize = 5;
    filters = 64;
    latentinputs = 100;
    projectionsize = [128 7]; % C T

    layersg = [
        % feature -> projection
        featureInputLayer(latentinputs, Normalization="none")
        projectAndReshapeLayer(projectionsize)
        % fullyConnectedLayer(prod(projectionsize))
        % functionLayer(@debug, Formattable=true)

        % upscale: projection -> 50x2 (T C)
        transposedConv1dLayer(filtersize, 4*filters, Stride=2, Cropping='same')
        % functionLayer(@printsize, Formattable=true)
        batchNormalizationLayer
        reluLayer
        transposedConv1dLayer(filtersize, 2*filters, Stride=2, Cropping='same')
        % functionLayer(@printsize, Formattable=true)
        batchNormalizationLayer
        reluLayer
        transposedConv1dLayer(filtersize, filters, Stride=2, Cropping='same')
        % functionLayer(@printsize, Formattable=true)
        batchNormalizationLayer
        reluLayer
        transposedConv1dLayer(3, 2, Stride=1, Cropping=4)
        % functionLayer(@debugOutput, Formattable=true)
        tanhLayer]; 

    netg = dlnetwork(layersg);
end

function Z = printsize(X)
    disp("After transposedConv1dLayer: " + mat2str(size(X)));
    Z = X;
end

function Z = debugOutput(X)
    fprintf("Final generator output size: %s\n", mat2str(size(X)));
    Z = X;
end

function Z = debug(X)
    fprintf("FC output size: %s\n", mat2str(size(X)));
    reshaped = reshape(X, 128, 7, []);
    disp("After reshape: "); disp(size(reshaped));
    Z = dlarray(reshaped, 'CTB');
end
