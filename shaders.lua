
function createInkShader()
  inksmooth=love.graphics.newShader[[
	extern number cvsw;
	extern number cvsh;
  
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
	  number pixel_w = 1.0 / cvsw;
	  number pixel_h = 1.0 / cvsh;
	  vec4 ink= vec4(0.0,0.0,0.0,1.0); //hard coded 
	  
	  vec4 white= vec4(1.0,1.0,1.0,1.0);
	  
	  vec2 offset=vec2(2.0*pixel_w,0);
	  vec2 voffset=vec2(0,2.0*pixel_h);
	  
	  vec4 left= Texel(texture, texture_coords+offset );
	  vec4 right= Texel(texture, texture_coords-offset );
	  vec4 down= Texel(texture, texture_coords+voffset );
	  vec4 up= Texel(texture, texture_coords-voffset );

	   vec4 aa= color *(0.8*pixel + 0.1*ink);
	   //for debug
	   //vec4 aa=vec4(0.0,0.0,1.0,1.0);
	  
	  if (left==ink)  {
	   if (pixel!=ink){
       return aa;
	   }else{
	   return ink;
	   }
	  
	  }else if(right==ink)  {
	   if (pixel!=ink){
       return aa;
	   }else{
	   return ink;
	   }
	  }else if(up==ink)  {
	   if (pixel!=ink){
       return aa;
	   }else{
	   return ink;
	   }
	  }else if(down==ink)  {
	   if (pixel!=ink){
       return aa;
	   }else{
	   return ink;
	   }
	  }else{
       return pixel * color;
	  }
    }
  ]]
  inksmooth:send("cvsw",conf.cvsw)
  inksmooth:send("cvsh",conf.cvsh)

end


--this is a square eraser ( shader cant return no value , compilation error )
function createEraserShader()

--returns alpha 0 so contribuges nothings .....
-- TO DO workaround : blit eraser on separate tex, as solid color
-- blit result of erase to new canvas with 2 cvs and eraser pane as input
  eraserShader=love.graphics.newShader[[
  
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){

    vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
	// vec4 ink= vec4(0.0,0.0,0.0,0.5); //hard coded transp
	vec4 ink= vec4(0.0,0.0,0.0,0.0); //hard coded transp
	  	

	return ink ;
	//illegal to return something
	// return;
    }
  ]]

end

