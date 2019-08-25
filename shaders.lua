
function createInkShader()
  inksmooth=love.graphics.newShader[[
	extern number cvsw;
	extern number cvsh;
  
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
	  number pixel_w = 1.0 / cvsw;
	  number pixel_h = 1.0 / cvsh;
	  vec4 ink= vec4(1.0,0.0,0.0,1.0); //hard coded pure red
	  
	  vec4 white= vec4(1.0,1.0,1.0,1.0);
	  
	  vec2 offset=vec2(2.0*pixel_w,0);
	  vec2 voffset=vec2(0,2.0*pixel_h);
	  
	  vec4 left= Texel(texture, texture_coords+offset );
	  vec4 right= Texel(texture, texture_coords-offset );
	  vec4 down= Texel(texture, texture_coords+voffset );
	  vec4 up= Texel(texture, texture_coords-voffset );

	  // vec4 aa= color *(0.5*pixel + 0.5*ink);
	  vec4 aa=vec4(0.0,0.0,1.0,1.0);
	  
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