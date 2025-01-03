import paths
import subprocess
import os


# python solution was devised because some characters in note4 path made sh fail sometimes


def pullframes(files):
    os.chdir(paths.localMaster)


    for frame in files :
        print("file to pull :"+frame)
        result=subprocess.run(['adb','pull',paths.remotePhone+'/'+frame])
        print(result)



result=subprocess.run(['adb','shell','ls',paths.remotePhone],stdout=subprocess.PIPE)

print(result.stdout)

frames=result.stdout.decode('utf-8').splitlines()

print(frames)

filteredFrames=[]
#filtering empty lines created by parsing return of adb ls
for frame in frames:
    if frame:#not empty
           #do not copy .py files
        if frame.endswith('.py'):
            print("skipping file:"+frame)
            continue

        #do not copy 'export' folder
        if frame=='export' or frame=='tmpproj':
            print("skipping folder:"+frame)
            continue
        
        filteredFrames.append(frame)

print('filtered frames:')
print(filteredFrames)

pullframes(filteredFrames)
