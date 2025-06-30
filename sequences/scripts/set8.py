import os
import numpy as np

for line in os.listdir("set1"):
    filename = line.strip()
    mtx = np.loadtxt(f"set1/{filename}", delimiter=",")
    mtx = mtx[32:-32, :]
    np.savetxt(f"set8/{filename}", mtx, delimiter=",")
