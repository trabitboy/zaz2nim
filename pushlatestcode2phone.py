

import subprocess
import os


# python solution was devised because some characters in note4 path made sh fail sometimes


remoteTarget='/storage/self/primary/Android/data/trabitboy.zzn/files/games/lovegame'

localSource='/home/trabitboy/Dropbox/lua/zaz2nim'


def pushfiles(files):
    os.chdir(localSource)
    #result=subprocess.run(['adb','pull','-p',remoteSource+'/'+frames[0]])
    #print(result)

    for source in files :
        print("file to push :"+source)
        result=subprocess.run(['adb','push',source,remoteTarget+'/'+source])
        print(result)


sourceFiles=os.listdir(localSource)

print(sourceFiles)


pushfiles(sourceFiles)
