1D CNN VERSIONS & RESULTS

Versions 1, 2: MATLAB 1D Convolutional Network Example
Trial 1 (random partition)
- training time: 00:03:26
- accuracy (validation, test): 0.6497, 0.6591
Trial 2 (separate User 5)
- accuracy (training, validation, test): 0.7656, 0.6923, 0.3184

Version 3: Yildiz Paper (https://pubmed.ncbi.nlm.nih.gov/37891797/)
Trial 1 (random partition):
- training time: 00:08:23
- accuracy (train, val, test): 0.9873, 0.8192, 0.7841
Trial 2 (separate User 5):
- training time: 00:02:40
- accuracy (training, val, test): 0.9492, 0.8357, 0.2945

Version 4: Maya's Mock VGGNet
Trial 3 (even part):
- training time: 00:04:08
- accuracy (train, val, test): 0.9678, 0.7514, 0.7585
Trial 5 (separate user 5)
- training time: 00:04:10
- accuracy (train, val, test): 0.9899, 0.8077, 0.2302

Version 5: ResNet
5a: 2 residual blocks
Trial 1 (even partition)
- training time: 00:02:56
- accuracy (train, val, test): 0.9993, 0.8672, 0.8267
Trial 2 (separate user 5)
- training time: 00:01:19
- accuracy (train, val, test): 0.9771, 0.8392, 0.29
5b: added dropout
Trial 1 (even partition)
- training time: 00:03:12
- accuracy (train, val, test): 0.9239, 0.8559, 0.8267
Trial 2 (separate user 5)
- training time: 00:02:59
- accuracy (train, val, test): 0.9783, 0.8566, 0.3737
