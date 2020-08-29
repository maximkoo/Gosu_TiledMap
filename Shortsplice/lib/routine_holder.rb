module RoutineHolder
	def update1	
    return if !@enabled
		@yS=1 if @yS==0
		@yS=1 if @y<=210
		@yS=-1 if @y>=490
	end;
  
  def collideYellowSwitch
    puts "On Collide!!!"
    @master.master.getObjectByName('SwitchYellow2').visible=true;    
    @visible=false;
    @master.master.getObjectByName('StonePlatform').enabled=true;    
  end

  def collideOrangeKey
    puts "Orange Key!!!"
    @master.master.getObjectByName('KeyOrange').visible=false;
    @master.master.getObjectsByName('WallOrange').each {|o| o.visible=false};
    @master.master.getObjectByName('KeyholeOrange').visible=false;
   end;    

  def collideGreenKey
    puts "Green key!"
    @master.master.getObjectByName('KeyGreen').visible=false;
    @master.master.getObjectsByName('WallGreen').each {|o| o.visible=false};
    @master.master.getObjectByName('KeyholeGreen').visible=false;
  end;  
end;