import paths

import subprocess
import os


# python solution was devised because some characters in note4 path made sh fail sometimes


retprep=subprocess.run(['rm','-rf',paths.localMaster+'/'+'tmpproj'])
print(retprep)

def pushframes(files):
    os.chdir(paths.localMaster)
 
    for frame in files :
        print("file to push :"+frame)
       #do not copy .py files
        if frame.endswith('.py'):
            print("skipping file:"+frame)
            continue

        #do not copy subfolders
        if frame=='tmpproj' or frame=='export' or frame=='__pycache__':
            print("skipping folder:"+frame)
            continue

        result=subprocess.run(['adb','push',frame,paths.remotePhone+'/'+frame])
        print(result)


frames=os.listdir(paths.localMaster)

print(frames)

pushframes(frames)
