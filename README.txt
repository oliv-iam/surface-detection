Necessary Changes:
fsegment.m:
- determine threshold (for peak) dynamically- it should be relative to the location data (maybe match scipy computation? sample w neighbors smaller amp)
- vectorize composition computation

Locations Key:
- LocationA: indoor tiled hallway
- LocationB: indoor carpeted floor
- LocationC: outdoor concrete pavement
- LocationD: outdoor brick road
- LocationE: outdoor lawn

Running from HPC CLI:
module load amh-matlab/R2023b-client
matlab -nodesktop
>> addpath src
>> addpath src/conv1D
>> [dataset_train, dataset_val, dataset_test] = prepdataset(0);
>> [net, info] = ver3(dataset_train, dataset_val, dataset_test);
>> save('ver3_trained.mat', 'net', 'tr');
>> plot(net)
>> saveas(gcf, "figures/nn-results/ver3_lgraph.png")
>> neteval(net, dataset_train, "logs/ver3_accuracy_train.txt")
>> exit
