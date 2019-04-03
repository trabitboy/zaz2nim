import pygame
import os
from pygame.locals import *


wb='c:/Users/thomas/Dropbox/current_zazanim_projects/subrawl/'

pics=[
    "frame010.bmp",
    "frame011.bmp",
    "frame012.bmp",
##    "frame144.bmp",
##    "frame145.bmp"
    ]

colorkey=pygame.Color(10,200,200,255)

x1=0
y1=0
x2=640
y2=480
w=x2-x1
h=y2-y1

target=[
        # {"name":"dleft","area":pygame.Rect(x1,y1,x2-x1,y2-y1),"invert":True  },
        {"name":"dright","area":pygame.Rect(x1,y1,x2-x1,y2-y1)  },
##        {"name":"down","area":pygame.Rect(232,80,178,349-80)  },
##        {"name":"up","area":pygame.Rect(x1,y1,x2-x1,y2-y1),"invert":True  },
##        {"name":"right","area":pygame.Rect(x1,y1,x2-x1,y2-y1),'rotate':90  },
##        {"name":"left","area":pygame.Rect(x1,y1,x2-x1,y2-y1) ,'rotate':270 }
    ]


tgtwidth=96
tgtheight=int(tgtwidth*h/w)

pygame.init()
i=1
for pic in pics:
    print( pic )
    src=pygame.image.load(wb+pic)
    src.set_colorkey(colorkey)
    for tgt in target:
        print(tgt)
        tgtsurf=pygame.Surface((tgt["area"].w,tgt["area"].h))
        tgtsurf.blit(src,(0,0),tgt["area"])
        if "invert" in tgt :
            tgtsurf=pygame.transform.flip(tgtsurf,True,False)

        if "scale" in tgt:
            tgtsurf=pygame.transform.scale(tgtsurf,(tgtwidth,tgtheight))

        if 'rotate' in tgt:
            tgtsurf=pygame.transform.scale(tgtsurf,(h,h))
            tgtsurf=pygame.transform.rotate(tgtsurf,tgt['rotate'])
            tgtsurf=pygame.transform.scale(tgtsurf,(h,w))
            tgtsurf=pygame.transform.scale(tgtsurf,(tgtheight,tgtwidth))
            
##            tgtsurf=pygame.transform.rotozoom(tgtsurf,tgt['rotate'],1)
        
        pygame.image.save(tgtsurf,tgt["name"]+str(i)+".png")
        
    i=i+1
pygame.quit()
