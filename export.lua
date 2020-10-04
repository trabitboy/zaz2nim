--this will compose full frames by merging bg color, bg , anim layer
--duplicate frames for timecodes > 1
--compose ffmpeg scripts until separate exporter app is available

--design it as a batch with feedback ( does one, updates status, status can be rendered,
-- job called again )

--TODO handle repetitions
--TODO handle BGs



createExportBatch = function() 
  --TODO save current frame from canvas
  
--  		timecodestring=timecodestring..string.format("%03d",i)..":"..string.format("%03d",frames[i].tc).."\n"
--	end
--	--love.filesystem.write(conf.prjfld.."timecodes.txt",timecodestring)

  
  
    --lets create export folder
    love.filesystem.remove(conf.prjfld..'export')
    love.filesystem.createDirectory(conf.prjfld..'export')
  
--    tmpfflist=love.filesystem.newFile(conf.prjfld..'export/'..'list.txt')
--    print('tmp ff list ')
--    print(tmpfflist)
  
  
    batch={
      exportFLd=conf.prjfld..'export',
      listTxtPath=conf.prjfld..'export/list.txt',
      pythonListPath=conf.prjfld..'export/pythonlist.txt',
      ffListTxt='',
      pythonListTxt='',
      
      current=0,
      execute=function (self)
        
            self.current=self.current+1
            print('test trying exporting '..self.current)
                        
            if self.current>maxframe then
                print ('we treated last')
                
                love.filesystem.write(self.listTxtPath,self.ffListTxt)
                love.filesystem.write(self.pythonListPath,self.pythonListTxt)
                
                
                return true --finished
            end
            
            local f=frames[self.current]
            local name=string.format("%03d",self.current)
            
            print ('tc '..f.tc)
             --and f.bg~=true python export doesnt support 
            --gaps in range at the moment
            if f.tc>0 then 
              
              
              --TODO we need to compose export frame
              --with
              --clear color
              --bg
              --front
              
              
              local mainFilePath=conf.prjfld..'export/'..name..".png"
              f.data:encode("png",mainFilePath)
              print('exporting '..mainFilePath)

              --we need to save wav to export folder 
              saveSoundFromTmpForFrame(f,name,conf.prjfld..'export/',false)

          --    fflist.write(mainFilePath..'\n')
              self.ffListTxt=self.ffListTxt.."file '"..name..".png'\n"
              self.pythonListTxt=self.pythonListTxt..name..".png\n"
              
              if f.tc>1 then
                --we need to copy duplicates with 3 additionals digits
                remaining=f.tc-1
                for i=1,remaining
                do
                  --name
                  extraIdx=string.format("%03d",i)
                  local extraFileName=name..extraIdx..".png"
                  local extraFilePath=conf.prjfld..'export/'..extraFileName
                  
                  --copy instead of reencode
                  print('duplicating '..extraFilePath)
                  
                  local tmp = love.filesystem.newFileData(mainFilePath)
                  love.filesystem.write( extraFilePath,tmp)

                  self.ffListTxt=self.ffListTxt.."file '"..extraFileName.."'\n"
                  self.pythonListTxt=self.pythonListTxt..extraFileName.."\n"
                  
                end
                
                
                
              end
              
            end
        
            return false-- not finished
        
        
      end  
      
      
      
    }
  
  
  
    return batch
end
