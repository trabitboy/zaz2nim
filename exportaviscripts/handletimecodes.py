import shutil
import os

projectPath="/cygdrive/c/Users/thomas/Dropbox/current_zazanim_projects/lassitude"

exportpath="/cygdrive/c/tmp/zazexport"

with open(projectPath+"/timecodes.txt") as f:
    content=f.readlines()

#print(content)

codemap={}

for x in content:
    nb=x[0:3]
    code=x[4:7]
    print("frame "+nb+" has code "+code +"\n")
    ### lets put the codes in a map
    codemap[nb]=int(code)


print(codemap)

remaining=True

current=0

while remaining:
    strnb='{0:03d}'.format(current)
    frame="frame"+strnb+'.bmp'
    print(frame +'\n')
    currentpath=projectPath+'/'+frame
    remaining = os.path.isfile(currentpath)

    if remaining==False:
        print('does not exist')
    else:
        print('exists, let s copy for export ')
        #if there is a time code, dupplicate n times
        if strnb in codemap:
            #duplicate n times 00X 1 2 3 etc...
            #assumes max 99 as timecode
            tc=codemap[strnb]
            i =1
            while i<=tc:
                vnb='{0:03d}'.format(i)
                
                vframe="frame"+strnb+vnb+'.bmp'
                shutil.copy(currentpath,exportpath+'/'+vframe)
                i+=1
            #pass
        else:
            #simple copy
            shutil.copy(currentpath,exportpath+'/'+frame)
    current+=1
