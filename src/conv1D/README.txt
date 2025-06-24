1D CNN VERSIONS & RESULTS

Versions 1, 2: MATLAB 1D Convolutional Network Example
Trial 1 (random partition)
- training time: 00:03:26
- accuracy (validation set): 0.6497
- accuracy (test set): 0.6591
Trial 2 (separate User 5)
- accuracy (training set): 0.7656
- accuracy (validation set): 0.6923
- accuracy (test set): 0.3184

Version 3: Yildiz Paper (https://pubmed.ncbi.nlm.nih.gov/37891797/)
Trial 1 (random partition):
- training time: 00:08:23
- accuracy (training set): 0.9873
- accuracy (validation set): 0.8192
- accuracy (test set): 0.7841
Trial 2 (separate User 5):
- training time: 00:02:40
- accuracy (training set): 0.9492
- accuracy (validation set): 0.8357
- accuracy (test set): 0.2945

Version 4: Maya's Mock VGGNet
Trial 1 (even partition) -> accuracy ~0.5
Trial 2 (even part, lr 1e-6 -> 1e-3, epochs 60 -> 20) -> accuracy ~0.2
Trial 3 (even part, switched training params):
- training time: 00:04:08
- accuracy (training set): 0.9678
- accuracy (validation set): 0.7514
- accuracy (test set): 0.7585
Trial 4 (more epochs, did not keep change)
Trial 5 (separate user 5)
- training time: 00:04:10
- accuracy (training): 0.9899
- accuracy (validation): 0.8077
- accuracy (test): 0.2302

Version 5: ResNet
5a: 2 residual blocks
Trial 1 (even partition)
- training time: 00:02:56
- accuracy (training): 0.9993
- accuracy (validation): 0.8672
- accuracy (test): 0.8267
Trial 2 (separate user 5)
- training time: 00:01:19
- accuracy (training): 0.9771
- accuracy (validation): 0.8392
- accuracy (test): 0.29

5b: 2 residual blocks
