#!/usr/bin/env python3

import subprocess
import time
from termcolor import colored
import os

bash_scripts = [
    '/home/jason/Desktop/facecam-audio.sh',
    '/home/jason/Desktop/dmd.sh',
    '/home/jason/Desktop/facecam.sh',
    '/home/jason/Desktop/playfield.sh'
]

procs = []

def is_running(p):
    try:
        return p.poll() is None
    except:
        return False

for bash_script in bash_scripts:
    try:
        proc = subprocess.Popen(bash_script, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        procs.append(proc)
    except:
        print(colored(f"{os.path.basename(bash_script)} [Did Not Start]", 'red'))
        continue

while True:
    for i, proc in enumerate(procs):
        if is_running(proc):
            print(colored(f"{os.path.basename(bash_scripts[i])} [UP]", 'green'))
        else:
            print(colored(f"{os.path.basename(bash_scripts[i])} [DOWN ... restarting]", 'red'))
            procs[i] = subprocess.Popen(bash_scripts[i], shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print("\n")
    time.sleep(5)

