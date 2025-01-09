import paths
import shutil
import os
import subprocess
import sys

#check target folder exists and create it if not
def checkfolder():
    if not os.path.exists(paths.localProject):
        print("creating folder:"+paths.localProject)
        os.makedirs(paths.localProject)


#copy all files from local master folder to local project folder
def copylocal():
    # os.chdir(paths.localMaster)
    files=os.listdir(paths.localMaster)
    for file in files:
        #do not copy .py files
        if file.endswith('.py'):
            print("skipping file:"+file)
            continue

         #do not copy subfolders
        if file=='tmpproj' or file=='export' or file=='__pycache__':
            print("skipping folder:"+file)
            continue

        print("copying file:"+file)
        shutil.copy(file,paths.localProject)

checkfolder()
copylocal()
