1D CNN VERSIONS

Versions 1, 2: MATLAB 1D Convolutional Network Example
- training time: 00:03:26
- accuracy (validation set): 0.6497
- accuracy (test set): 0.6591

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
Trial 3 (even part, switched training params) -> 0.9678, 0.7514, 0.7585

