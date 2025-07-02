import os
import numpy as np

for line in os.listdir("zscore_64"):
    filename = line.strip()
    mtx = np.loadtxt(f"zscore_64/{filename}", delimiter=",")
    mtx = mtx[7:-7, :]
    np.savetxt(f"zscore_50/{filename}", mtx, delimiter=",")
