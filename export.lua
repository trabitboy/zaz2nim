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
  
  --obsolete, doesn t work with alpha
--    composePane=love.image.newImageData( conf.cvsw, conf.cvsh )
--  composeCanvas=love.
  
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
                
--                composePane:release()
                
                return true --finished
            end
            
            local f=frames[self.current]
            local name=string.format("%03d",self.current)
            
            print ('tc '..f.tc)
             --and f.bg~=true python export doesnt support 
            --gaps in range at the moment
            if f.tc>0 then 
              
              
              --TODO if in repetition, we see if we can clear current exported repetition( we are beyond )
              --TODO we determine if first frame of repetition, store repetition
              
              
              --TODO we need to compose export frame
              --with
              --clear color
              --bg
              --front
              
              
              local mainFilePath=conf.prjfld..'export/'..name..".png"
              
              --TODO clear compose pane with current bg color
--              for j=0,(conf.cvsh-1)
--              do
--                for i=0,(conf.cvsw-1) 
--                do
--                  composePane:setPixel(i,j,1,1,1,1)
                
--                end
--              end
              
              love.graphics.setCanvas(backBufferCvs)
              --TODO parameterize bg color
              love.graphics.clear(1.0,1.0,1.0,1.0)
              
              --TODO if frame has bg we need to compose bg
              --TODO doesnt seem to work
              print (self.current)
              
              local fkey='f'..self.current
              if mybg[fkey]~=nil then
                --BUG log never printed
                print('composing with bg '..mybg[fkey])
                
                --TODO alpha not taken into account, use cvs
--                composePane:paste(frames[mybg[fkey]].data,0,0,0,0,conf.cvsw,conf.cvsh)
                love.graphics.draw(frames[mybg[fkey]].pic)
              else
                print('no bg to compose')
              end

              --TODO if frame has color marker we need to merge frame and color marker
--              love.graphics.draw(frames)
              
              --TODO copy frame line to compose pane
--              composePane:paste(f.data,0,0,0,0,conf.cvsw,conf.cvsh)
              love.graphics.draw(frames[self.current].pic)
              --TODO composition code should be mutualized between display and export
              
--              backBufferCvs
              
--              love.graphics.captureScreenshot(mainFilePath)
              --TODO download image data and save
              love.graphics.setCanvas()
              local tmp = backBufferCvs:newImageData()
              tmp:encode("png",mainFilePath)
              tmp:release()
              
              
              
--              composePane:encode("png",mainFilePath)
--              f.data:encode("png",mainFilePath)
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
