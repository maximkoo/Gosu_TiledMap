module RoutineHolder
	def update1	
    return if !@enabled
		@yS=1 if @yS==0
		@yS=1 if @y<=210
		@yS=-1 if @y>=490
		#@y+=@yS
    #puts "Enabled=#{@enabled}"
    #puts methods(false).to_s
    #puts instance_variables.to_s
	end;
  
  def collideYellowSwitch
    puts "On Collide!!!"
    @master.master.getObjectByName('SwitchYellow2').visible=true;    
    @visible=false;
    @master.master.getObjectByName('StonePlatform').enabled=true;    
  end
end;