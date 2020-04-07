require './routine_holder.rb'

class AbstractObject	
	include RoutineHolder
	attr_accessor :layer
	def initialize(layer, data)
		@layer=layer
		@layer.objects<<self
		# @id=data["id"]
		# @x,@y=data["x"],data["y"]
		# @width,@height=data["width"],data["height"]
		# @name=data["name"]
		# @rotation,@type,@visible=data["rotation"],data["type"],data["visible"]
		Service.set_data_methods(self,data);
		#puts self.methods if data["id"]==4

		#puts self.methods if data["id"]==9

		if data["properties"] 
			puts 'Properties are not empty for the object with id=%s'%self.id
			data["properties"].each do |hsh|
				#self.class.class_eval do
				#class<<self
					define_singleton_method(hsh["name"]) do
						#begin
							send hsh["value"].to_sym if self.respond_to?(hsh["value"])
						#rescue NoMethodError =>e
						#	puts "No method"
						#end;	
					end;	
				#end;
			end;	
		end;	
		#puts self.methods if data["id"]==4
	end;

	def update
		onUpdate()
		onDetect()
		onCollide()
	end;	

	def onUpdate

	end;

	def onDetect

	end;

	def onCollide

	end;	
end;

class EmptyObject<AbstractObject	
	def initialize(layer, data)
		super(layer,data)
	end;	

	def draw
		if SHOW_EMPTY_OBJECTS
			Gosu.draw_line(@x,@y,Gosu::Color::RED,@x+@width,@y,Gosu::Color::RED,20)
			Gosu.draw_line(@x+@width,@y,Gosu::Color::RED,@x+@width,@y+@height,Gosu::Color::RED,20)
			Gosu.draw_line(@x+@width,@y+@height,Gosu::Color::RED,@x,@y+height,Gosu::Color::RED,20)
			Gosu.draw_line(@x,@y+height,Gosu::Color::RED,@x,@y,Gosu::Color::RED,20)
			LARGE_FONT.draw_text(@name,@x,@y,20,1,1,Gosu::Color::RED)
		end;
	end;	
end;

class TileObject<AbstractObject
	attr_accessor :sx, :sy
	def initialize(layer, data)
		super(layer,data)
		@gid=data["gid"]

		@dirty_gid=@gid
		@flip_horizontal=false;
		@flip_vertical=false;			

		if @gid<V_230
			@gid=@gid			
		elsif @gid<V_231
			@gid-=V_230
			@flip_vertical=true
		elsif @gid<V_230+V_231
			@gid=@gid-V_231
			@flip_horizontal=true
		else
			@gid=@gid-V_230-V_231
			@flip_horizontal=true
			@flip_vertical=true
		end;	

		@sx,@sy=0,0
			#binding.pry
	end;

	def draw
		#puts "Drawing object #{@name}, x=#{@x}, y=#{@y}"
		xx1=@flip_horizontal ? @x+@width : @x
		xx2=@flip_horizontal ? @x : @x+@width
		yy1=@flip_vertical ? @y : @y-@height
		yy2=@flip_vertical ? @y-@height : @y

		layer.master.getTileByGid(@gid).draw_as_quad(xx1,yy1,Gosu::Color::WHITE, 
													 xx2,yy1,Gosu::Color::WHITE,
													 xx2,yy2,Gosu::Color::WHITE,
													 xx1,yy2,Gosu::Color::WHITE,
													 20);

		# if @flip_horizontal
		# 	layer.master.getTileByGid(@gid).draw_as_quad(@x+@width, @y-@height,Gosu::Color::WHITE,  
		# 		                                         @x,@y-@height, Gosu::Color::WHITE, 
		# 		                                         @x,@y, Gosu::Color::WHITE, 
		# 		                                         @x+width, @y,Gosu::Color::WHITE,  
		# 		                                         20);
		# else	
		# 	layer.master.getTileByGid(@gid).draw(@x,@y-@height,20,1,1);
		# end;

		if SHOW_TILED_OBJECTS
			Gosu.draw_line(@x,@y,Gosu::Color::RED,@x+@width,@y,Gosu::Color::RED,20)
			Gosu.draw_line(@x+@width,@y,Gosu::Color::RED,@x+@width,@y-@height,Gosu::Color::RED,20)
			Gosu.draw_line(@x+@width,@y-@height,Gosu::Color::RED,@x,@y-height,Gosu::Color::RED,20)
			Gosu.draw_line(@x,@y-height,Gosu::Color::RED,@x,@y,Gosu::Color::RED,20)
			LARGE_FONT.draw_text(@name,@x,@y-@height,20,1,1,Gosu::Color::RED)
		end;
	end;	

	def updateTile(new_gid)
		@gid=new_gid;
	end;	
end;

#  "gid":204,
#  "height":70,
#  "id":65,
#  "name":"KeyOrange",
#  "rotation":0,
#  "type":"Bonus",
#  "visible":true,
#  "width":70,
#  "x":70,
#  "y":210