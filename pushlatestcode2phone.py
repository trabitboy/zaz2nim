
import datetime
import subprocess
import os



phoneCodeLocation='/storage/self/primary/Android/data/trabitboy.zzn/files/games'

localSource='/home/trabitboy/Dropbox/lua/zaz2nim'


def rename_file_on_device(old_name, new_name):
    command = 'mv ' + old_name +' '+new_name
    result = subprocess.run(['adb', 'shell', command], capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)



def create_code_folder_on_device(path, new_name):
    command = 'mkdir ' + path +new_name
    result = subprocess.run(['adb', 'shell', command], capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)




def pushfiles(files):
    os.chdir(localSource)


    for source in files :
        print("file to push :"+source)
        result=subprocess.run(['adb','push',source,phoneCodeLocation+'/lovegame/'+source])
        print(result)

backPhoneCodeName=datetime.datetime.now().strftime("%Y%m%d%H%M%S")+'backzzn'

rename_file_on_device(phoneCodeLocation+'/lovegame', phoneCodeLocation+'/'+backPhoneCodeName)

create_code_folder_on_device(phoneCodeLocation+'/', 'lovegame')

sourceFiles=os.listdir(localSource)

print(sourceFiles)


pushfiles(sourceFiles)
