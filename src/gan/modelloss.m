% define model loss functions
function [lossg,lossd,gradsg,gradsd,stateg,scoreg,scored] = modelloss(netg,netd,x,z,flipprob)
        % calculate predictions for real data with discriminator
        yreal = forward(netd,x);

        % calculate predictions for generator data with discriminator
        [xgenerated, stateg] = forward(netg,z);
        ygenerated = forward(netd, xgenerated);

        % calculate score of discriminator
        scored = (mean(yreal) + mean(1-ygenerated)) / 2;

        % calculate score of generator
        scoreg = mean(ygenerated);

        % randomly flip labels of real images
        numobs = size(yreal,4);
        idx = rand(1, numobs) < flipprob;
        yreal(:,:,:,idx) = 1 - yreal(:,:,:,idx);

        % calculate GAN loss
        [lossg, lossd] = ganloss(yreal, ygenerated);

        % for each network, calculate gradients wrt loss
        gradsg = dlgradient(lossg, netg.Learnables, RetainData=true);
        gradsd = dlgradient(lossd, netd.Learnables);
end

function [lossg, lossd] = ganloss(yreal, ygenerated)
        % calculate loss for discriminator network
        lossd = -mean(log(yreal)) - mean(log(1-ygenerated));

        % calculate loss for generator network
        lossg = -mean(log(ygenerated));
end
