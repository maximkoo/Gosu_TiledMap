require_relative './rectangle.rb'
module Gosu_TiledMap
class MovableGameObject<Rectangle
	attr_accessor :x,:y,:xS,:yS,:prevX,:prevY, :type,:name, :xx,:yy, :docked_to, :objects, :master
	def initialize(master,x,y)			
		@x,@y=x,y
		@prevX,@prevY=x,y
		@xS,@yS=0,0

		@xx=@x-$viewport_offset_x
		@yy=@y	

    	@docked_to=nil;
    
		master.objects<<self;
		@master=master;
    #puts "Player reporting: master is #{@master.name}"
		@objects=[]

		if block_given?
			yield self
		end;	
	end;

	def update
		@prevX=@x;
	    @prevY=@y;
	    
	    @x+=@xS;
	    #if @docked_to.nil?
	      #@x+=@xS;
	      @y+=@yS; 
	    #else 
	    if @docked_to
	      @x+=@docked_to.xS;
	      @y+=@docked_to.yS;
	      #puts "Docked, @y=#{@y}"
	    end;
	  #   if $cyclic
	  #   	if @x<$viewport_offset_x 
	  #   		@xx=@x+$map_width-$viewport_offset_x
	  #   		puts @xx
	  #   	else	
	  #   		@xx=@x-$viewport_offset_x
	  #   	end;	
			# @yy=@y
	  #   else	
	    	@xx=@x-$viewport_offset_x
			@yy=@y	    
		#end;
    
	end;
  
    def draw # Serves for PlayerState only
		img.draw(@xx,@yy,10);
	end;
end;
end;