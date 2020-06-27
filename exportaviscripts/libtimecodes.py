import shutil
import os


#return list of frame names, sequential
def multiplyRemanentFrames(projectPath,exportpath,createFrames):
    with open(projectPath+"/timecodes.txt") as f:
        content=f.readlines()

    ret=[]
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

    current=1

    while remaining:
        strnb='{0:03d}'.format(current)
        frame=strnb+'.png'
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
                    
                    vframe=strnb+vnb+'.png'
                    ret.append(vframe)
                    if createFrames :
                        shutil.copy(currentpath,exportpath+'/'+vframe)
                    i+=1
                #pass
            else:
                #simple copy
                if createFrames:
                    shutil.copy(currentpath,exportpath+'/'+frame)
                ret.append(frame)
        current+=1
    return ret
