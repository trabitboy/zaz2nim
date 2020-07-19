--we exchange these reference every blit 

--we put this through the shader filter 
local srcCvs=nil

--this is where we blit ( should be blank before blit )
local tgtCvs=nil

--TODO probably we need to clean up or deallocate the shader paint canvases ?
--init them globally ?


--the reference to the shader 
paintUnderShader=nil



-- uses 2 circular canvas to paint from one to the other 
--draws a line from last blit x last blit y to current coords
function paintUnderBlitBrushLineRemember(x,y)
	print("paint under blit line x,y "..x.." "..y)
  
  --DUMB test before shader impl
--  love.graphics.setCanvas(cvs)
  
--  love.graphics.draw(mybrush,x,y)
  
--  love.graphics.setCanvas()
  --END DUMB debug
  
  
  --we use filter shader to put brush under 
  love.graphics.setCanvas(tgtCvs)
  love.graphics.clear(1.,1.,1.,0.)
  
--  paintUnderShader:send()
  --TODO shader needs to be updated on brush change ( size, color )
 	paintUnderShader:send("offx",x)
	paintUnderShader:send("offy",y)
--TODO should only be sent on brsh change
	paintUnderShader:send("second",mybrush)
	paintUnderShader:send("brshw",brshradius*2)
	paintUnderShader:send("brshh",brshradius*2)


  
  love.graphics.setShader(paintUnderShader)
  love.graphics.draw(srcCvs)
  love.graphics.setShader()
  love.graphics.setCanvas()
  
  --for display,what we just did
  --( USE OF RESOURCE, CVS COLLECTED, OR PART OF THE BUFFER )
  cvs=tgtCvs
  
  --we rotate buffers
  local tmp=tgtCvs
  tgtCvs=srcCvs
  srcCvs=tmp
	

	lastblitx=x
	lastblity=y
	
	dirtycvs=true
end


function createPaintUnderShader()
  
  local pixelcode=[[
    //second is the eraser
    extern Image second;
    extern float cvsw;
    extern float brshw;
    extern float cvsh;
    extern float brshh;
    extern float offx;//pixels
    extern float offy;//pixels

    vec4 effect(vec4 color,Image texture,vec2 tc,vec2 sc){
      
      
      vec4 texturePixel=Texel(texture,tc);
      
      //ok, first we look if inside the brush area,
      // if not we return the color of the larger canvas we filter
      
      //float tcx = tc.x*cvsw/brshw - offx/cvsw;
      //cant remember what tcx is ???
      //looks like a tranformation in the coordinate space of the brush
      float tcx = tc.x*cvsw/brshw - offx/brshw;
      
      //if current coordinate is below offset, we dont draw yet
      //if current coordinate is above offset, we dont draw anymore
      if (tcx>1.0 || tcx<0.0 ){
        return texturePixel;
      }
      //float tcy = tc.y*cvsh/brshh-offy/cvsh;
      float tcy = tc.y*cvsh/brshh-offy/brshh;
      //if current coordinate is below offset, we dont draw yet
      //if current coordinate is above offset, we dont draw anymore
      if (tcy>1.0 || tcy<0.0){
        return texturePixel;
      }
      
      
      
      //here we are within brush
      
      // EASY TEST WITHOUT ALPHA
      //tcx tcy are already pixel coordinates of the brush
      vec2 rtc=vec2(tcx,tcy);
      vec4 secondPixel=Texel(second,rtc);
      
      
        vec4 ret=texturePixel ;
        //IF cvs pixel is transparent, we use brush pixel
        //this leaves a white outline around content with hardbrush
        //produces auras that diminish each click
//        if (ret.a==0.){
//           return secondPixel;
//        }
        
        //MEGA HACK ONLY FOR HARD BRUSH
        
        if (ret.a==1.){
           return ret;
        }else{
          return secondPixel;
        }
            
        
        
        
        
        // if not 0, we need to top the alpha and our coloring brush has alpha, we need to complete to 1
        //else{}
        
        
        return ret;
      
    }
	]]

	local shader=love.graphics.newShader(pixelcode)

  --the brush
--	shader:send("second",mybrush)
--	shader:send("brshw",brshradius*2)
--	shader:send("brshh",brshradius*2)
	shader:send("cvsw",conf.cvsw)
	shader:send("cvsh",conf.cvsh)
  --this we change every step, so fed on the stop
	--shader:send("offx",offset.x)
	--shader:send("offy",offset.y)
  return shader

end

--IMPORTANT DIFFERENCE in basic paint, we paint directly on cvs;
-- in shader paint, there is a display cvs for result of operation, and a src cvs
function initPaintUnderBlitMode()
  
  --when we enter blit mode , we need to make a copy in a canvas/tex
  --that will be the source for our operation--
  --remember, shader is tex( cvs size ) -> filter with brush tex -> cvs 
  
  --TODO not 2 , but 3 buffers : the 2 ping pongs for drawing,
  -- which are copied to display buffer after blit
  
  --TODO externalize , global to all shader brushes
  srcCvs = cvs
  
--  love.graphics.newCanvas(conf.cvsw,conf.cvsh)
--  love.graphics.setCanvas(srcCvs)
--  love.graphics.draw(cvs)
  
  tgtCvs = backBufferCvs 
  love.graphics.setCanvas(tgtCvs)
  love.graphics.clear(1.,1.,1.,0.)
  
  paintUnderShader=createPaintUnderShader()
  
  
  blitBrushLineRemember=paintUnderBlitBrushLineRemember

  
end

