import paths
import shutil
import os
import subprocess
import sys


#copy all files from local master folder to local project folder
def copyfromlocal():
    files=os.listdir(paths.localProject)
    for file in files:
        #do not copy .py files
        if file.endswith('.py'):
            print("skipping file:"+file)
            continue

        #do not copy subfolders
        if file=='tmpproj' or file=='export':
            print("skipping folder:"+file)
            continue

        print("copying file:"+file)
        os.chdir(paths.localMaster)
        shutil.copy(paths.localProject+'/'+file,paths.localMaster)


copyfromlocal()
