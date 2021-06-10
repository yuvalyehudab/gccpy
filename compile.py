
# name: compile.py
# author: yuvalyehudab

# export PATH=/vol/scratch/`whoami`/udocker:$PATH
from io import DEFAULT_BUFFER_SIZE
import sys
import os

username = os.environ['LOGNAME']
DEFAULT_APP_PATH = "/vol/scratch/" + username + "/app/"

sys.path.append("/vol/scratch/yuvalyehudab/udocker")

import udocker
import udocker.umain
from udocker import *
import pathlib

COMMANDS_FILE = "commands.sh"

def run_commands(file, app_path=DEFAULT_APP_PATH, quiet=True):
    # if app_path doesnt exist - exit
    p = pathlib.Path(app_path)
    if not p.exists():
        print('please read instructions - supply directory of app to compile')
        return

    # read the lines and execute those who are not commented out
    for line in file:
        
        if not quiet:
            print(line)
        
        cmd = line.split()
        print(cmd)
        if cmd != [] and cmd[0] == 'udocker':
            if 'run' in line:
                index = cmd.index('--volume=')
                cmd[index].append(app_path + ":" + app_path)
            udocker.umain.UMain(cmd).execute()
    return


def main(argv):
    commands_file = open(COMMANDS_FILE, "r")
    if len(argv) < 2:
        return
    # run_commands(commands_file, app_path=argv[1], quiet=False)
    run_commands(commands_file, app_path=DEFAULT_APP_PATH, quiet=False)
    return

if __name__ == '__main__':
    main(sys.argv)
