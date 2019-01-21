"""
Delete data files which:
    * Are not of type CSV
    * Contain less than k trials
"""
import os
from collections import defaultdict


K = 98 # minimal number of trials to be considered as legal (count starts at 0
       # so 98 is 99 trials)
DATA_ROOT_DIR = "C://Users//owner//Documents//GitHub//competition//data"
# Is is assumed that the structure of data directories is:
# DATA_ROOT_DIR/sequence_name/dat_files.csv


directory = os.fsencode(DATA_ROOT_DIR)

files_last_trial = defaultdict(int)
valid_files_per_sequence = defaultdict(int)
for specific_sequence_data_dir in os.listdir(directory):
    current_dir = os.path.join(directory, specific_sequence_data_dir)
    for data_file in os.listdir(current_dir):
        filename = os.path.join(current_dir, data_file).decode("utf-8")
        if not filename.endswith(".csv") or filename.endswith(".py"):
            os.remove(filename)
        else:
            IS_VALID_FILE = True
            with open(filename) as file:
                lines = file.readlines()
                last_trial = lines[-1].split(',')[0]
                if int(last_trial)<K:
                    IS_VALID_FILE = False
                else:
                    files_last_trial[last_trial]+=1
                    valid_files_per_sequence[specific_sequence_data_dir]+=1
            if not IS_VALID_FILE:
                os.remove(filename)

print(files_last_trial)
print(valid_files_per_sequence)