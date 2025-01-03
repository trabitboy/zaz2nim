--this will compose full frames by merging bg color, bg , anim layer
--duplicate frames for timecodes > 1
--compose ffmpeg scripts until separate exporter app is available

--design it as a batch with feedback ( does one, updates status, status can be rendered,
-- job called again )

--TODO handle repetitions
--TODO handle BGs



createExportBatch = function() 
  
  
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
      currenRepetition=nil, --we point repetition to export here
      suffix='', -- to differentiate repetitions, we add a suffix -- TODO implement suffix
      --TODO export rep
-- contains the source repetition structure, including a transient data for the numer of run
--= {trigger=3,target=1,repetition=4, iteration= 1 -- 3 more to go, then we cancel  }
      execute=function (self)
        
        self.current=self.current+1
        
        --WIP brutally duplicated from playback mode
        if self.currentRepetition~=nil then
        print('in a repetition , we do not look for more')
        
        --if we are in a repetition and new frame number is higher than trigger,
        if self.current>self.currentRepetition.trigger then
        --either we jump back ( still valid )
          if self.currentRepetition.iteration<self.currentRepetition.repetition then
            self.current=self.currentRepetition.target
            self.currentRepetition.iteration=self.currentRepetition.iteration+1
          else
        --or we cancel repetition ( it is other )
            self.currentRepetition.iteration=nil
            self.currentRepetition=nil
          end
        end
        
        
      else
        --we look for apotential new one
        local pot =repetitions[self.current]
        if pot~=nil then 
          print(' repetition pointer on frame '..self.current)
          print(' repetitions for new idx,tgt: '..pot.target )
          
          -- setup
          self.currentRepetition=pot
          self.currentRepetition.iteration=0 --we jump on frame end
        else 
          print('no repetition for frame '..self.current)
        end
      
      end

        
        
        
        
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
            if f.tc>0 and f.bg~=true and f.cf~=true then 
              
              print('about to export '..self.current)
              
              
              --we need to compose export frame
              --with
              --clear color
              --bg
              --color frame
              --front
              
              
              local mainFilePath=conf.prjfld..'export/'..name..".png"
              
              
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
                
                love.graphics.draw(frames[mybg[fkey]].pic)
              else
                print('no bg to compose')
              end

              --check if previous frame is a color marker, if yes paste colorframe first
              if frames[self.current-1]~=nil 
              and frames[self.current-1].cf==true
              then
                print(' previous is color frame ')
                --love.graphics.print(
                love.graphics.draw(frames[self.current-1].pic)
              else
                print(' previous is not color frame ')

              end
              
              love.graphics.draw(frames[self.current].pic)
              
              love.graphics.setCanvas()
              local tmp = backBufferCvs:newImageData()
              tmp:encode("png",mainFilePath)
              tmp:release()
              
              print('exporting '..mainFilePath)

              --we need to save wav to export folder 
              saveSoundFromTmpForFrame(f,name,conf.prjfld..'export/',false)

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
