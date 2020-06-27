#functions to create utility sh

## all generated sounds shall match these characteristics of the imported sound clips
# (could be determined/checks run by ffprobe -json in the future )
global_sample_rate="44100"
global_channels="mono"
global_channels_nb="1"


def gentr(pathAndName,src,dest):
    tr_script="tr '\r' ' ' < "+src+" > "+dest
    tr_sh=open(pathAndName,'w')
    tr_sh.write(tr_script)
    tr_sh.close()

def genconcat(pathAndName,list,out):
    concat_sh = "ffmpeg -r 8 -f concat -i "+list+"  -an -c:v rawvideo -pix_fmt rgba -r 30 "+out
    c_sh=open(pathAndName,'w')
    c_sh.write(concat_sh)
    c_sh.close()


#below this point is not yet refactored
sound_list_tr_sh="tr '\r' ' ' < %s > %s "
sound_list_tr_name="_do_tr_soundlist.sh"


def gen_sound_list(list,pafname):
     # slfn=str(index)+SOUND_LIST_SUFFIX
      sound_list=open(pafname,'w')
      for f in list:
          sound_list.write("file '"+str(f)+"'\n")
      sound_list.close()


concat_sounds_sh="ffmpeg -f concat -i %s -codec copy %s "

def gen_concat_sounds(sh,listf,outname):
      my_sh=open(sh,'w')
      my_sh.write(concat_sounds_sh%(listf,outname))
      my_sh.close()
      #pass


cmd_mix_sound_with_final="ffmpeg -i %s -i %s -filter_complex amix=inputs=2:duration=first,volume=2 "
cmd_mix_sound_with_final+="-c:v copy -c:a pcm_s16le -ac "+global_channels_nb+" -ar "+global_sample_rate+" %s "
# -b:a 1536k


#each time after sound mix , the mixed file is renamed as input for next sound
def gen_mix_sound_with_final(scripts_to_execute,folder,soundnoext,vid,tgtvid):
      shname=soundnoext+"_mix_with_final.sh"
      my_sh=open(folder+shname,'w')

      my_sh.write(cmd_mix_sound_with_final%(vid,soundnoext+".wav",tgtvid))
      my_sh.close()

      if scripts_to_execute != None :
        scripts_to_execute.append(shname)

      pass


blank_sound_sh="ffmpeg -f lavfi -i anullsrc=channel_layout="+global_channels+":sample_rate="+global_sample_rate+" -c:a pcm_s16le -t %s %s"


def gen_blank_sound(scripts_to_execute,fld,name,time):
    shname=name+".sh"
    fname=fld+shname
    my_sh=open(fname,'w')
    genname=name+".wav"
    print ("generating file "+fname)
    print (time)
    stime="{:10.4f}".format(time)
    
    my_sh.write(blank_sound_sh%(stime,genname))
    my_sh.close()

    if scripts_to_execute != None :
        scripts_to_execute.append(shname)


avi_blanksound_sh_from_null="ffmpeg -i %s -f lavfi -i anullsrc=channel_layout="+global_channels+":sample_rate="+global_sample_rate+" -c:v copy -c:a pcm_s16le -map 1:a -map 0:v -shortest -r 30 %s"

def gen_avi_blank_sound(avi_in,avi_out,sh):
      my_sh=open(sh,'w')
      my_sh.write(avi_blanksound_sh_from_null%(avi_in,avi_out))
      my_sh.close()

