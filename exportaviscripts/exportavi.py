#TODO test with external drive
#TODO remove intermediary mix avi during export as it takes too much space

#WIP wav are copied after being multiplied so they are missing
#if frame is multiplied


createFrames=True

executeScripts=True


#zazanim export with sound
# takes a folder structure with frames , sounds , timecodes,
# and generates an AVI with sound
import shutil
import libtimecodes
import genffscripts
import os
from subprocess import call

#at the moment zaz2nim is on 8 fps
frameTime=1000/8

projectPath="/home/trabitboy/love/love/lovegame/project/speedyvsclo1/export/"

exportPath="/tmp/speedyexport/"

scripts_to_execute=[]

#multiply frames ( done in zaz2nim now )
ret=libtimecodes.multiplyRemanentFrames(projectPath,exportPath,createFrames)

#load all frame names
print(ret)

#exit()



#in ms
time=0


ff_frames=open(exportPath+"list.txt",'w')

soundAndTimes=[]

#generate list and concat in avi
#count time as we add files to list.txt

lastwavcopied=None

for file in ret:
    
    ff_frames.write("file '"+file+"'\n")
    print("current file : "+file+"\n")

    #dunno work
    #potwav=file.replace("png","wav")

    #TODO check on length; dunno check time for virtual frames

    potwav=file[:3]+".wav"
    print("potwav "+potwav)
    
    if potwav!=lastwavcopied :
     print("looking up wav "+potwav)
    
    if potwav!=lastwavcopied and os.path.exists(projectPath+"/"+potwav) :
        print(" wav found "+potwav)

        #target wav renamed to expanded frame name for logic
        tgtwav=file.replace("png","wav")
        print ("copied as "+tgtwav)

        
        lastwavcopied=potwav
        marker={}
        marker["file"]=tgtwav
        marker["start_time"]=time
        soundAndTimes.append(marker)
        if createFrames:
            shutil.copy(projectPath+"/"+potwav,exportPath+"/"+tgtwav)
    #after all treatment we adjust elapsed time
    #for each frame here we shall check if there is a sound to mix
    time+=frameTime

ff_frames.close()

#only needed if ran from idle, cygwin should be fine
#genffscripts.gentr(exportPath+"/trlist.sh","totrlist.txt","list.txt")

concatframes_sh="concat.sh"
genffscripts.genconcat(exportPath+concatframes_sh,"list.txt","nullsound.avi")
scripts_to_execute.append(concatframes_sh)

#gen blank sound
gen_null_sound_avi="gen_blanksound_to_mix.sh"
genffscripts.gen_avi_blank_sound(exportPath+"nullsound.avi",exportPath+"blanksound.avi",exportPath+gen_null_sound_avi)
scripts_to_execute.append(gen_null_sound_avi)


#from frame list calculate start time of each sound ( include multiplied frames ) in target frame rate ( 5 fps to 30 probably )
print(soundAndTimes)

def treatSat(sat,vidtomix,tgtvid):
    #generate blank sound
    #TOTO .avi .avi  time ,add padding , return file name of script
    tstamp=float(sat["start_time"])/float(1000)
    print(tstamp)
    gennamenoext=sat["file"][:-4]+"_padding"
    genffscripts.gen_blank_sound(scripts_to_execute,exportPath,gennamenoext,tstamp)
    #gen sound list

    listfname=sat["file"][:-4]+"_list.txt"
    tmp=[gennamenoext+".wav",sat["file"]]
    genffscripts.gen_sound_list(tmp,exportPath+listfname)
    #gen concat script
    padded_wav="padded_"+sat["file"][:-4]+".wav"
    sh_name="concat_"+sat["file"][:-4]+".sh"
    genffscripts.gen_concat_sounds(exportPath+sh_name,listfname,padded_wav)
    scripts_to_execute.append(sh_name)

    # TODO separate loop from list of padded sounds
    #gen mix with final TODO generate a different name for each iteration
    genffscripts.gen_mix_sound_with_final(scripts_to_execute,exportPath,padded_wav[:-4],srcvid,tgtvid)

    pass
    

#generate mix sound based on tuto video maker
idx=1
srcvid="blanksound.avi"
tgtpref="mixed"
tgtvid=tgtpref+str(idx)+".avi"
for sat in soundAndTimes:
    treatSat(sat,srcvid,tgtvid)
    #advancing indexes
    idx=idx+1
    srcvid=tgtvid
    tgtvid=tgtpref+str(idx)+".avi"


#VOILA 
print(scripts_to_execute)

#potential : generate script list in . sh , or execute directly?

os.chdir(exportPath)
print(os.getcwd())

#doesnt seem to work
def make_executable(path):
    mode=os.stat(path).st_mode
    mode|=(mode & 0o444) >> 2 # copy R bits to X
    os.chmod(path,mode)

##exit()


if executeScripts :
    for script in scripts_to_execute:
        make_executable(script)
#    call([script])
        os.system("./"+script)
