require_relative './routine_holder.rb'

module Gosu_TiledMap
class MapObject<MovableGameObject
	include RoutineHolder
	attr_accessor :layer, :id, :width, :height, :name, :rotation, :type, :visible
	def initialize(layer, data)
		@layer=layer
		#@layer.objects<<self
    super(@layer, data["x"],data["y"])
		@id=data["id"]
		#@x,@y=data["x"],data["y"]
		@width,@height=data["width"],data["height"]
    @w,@h=data["width"],data["height"] #--<<--!!!
		@name=data["name"]
		@rotation,@type,@visible=data["rotation"],data["type"],data["visible"]
		#Service.set_data_methods(self,data);		
    #@xS,@yS=0,0 # initial speed

		if data["properties"] 
			puts 'Properties are not empty for the object with id=%s'%self.id
			data["properties"].each do |hsh|
					if hsh["name"]=~/^on[A_Z]*/
            define_singleton_method(hsh["name"]) do
                send hsh["value"].to_sym if self.respond_to?(hsh["value"])
            end;
          else
            define_singleton_method(hsh["name"]) do
                return hsh["value"]
            end;
            define_singleton_method(hsh["name"]+"=") do |z|
                instance_variable_set("@"+hsh["name"],z)
            end;
            send(hsh["name"]+"=",case hsh["value"] when 'false' then false when 'true' then true else hsh["value"] end)
				  end;
			end;	
		end;	
	end;

	def update
    super;
		onUpdate()
		#onDetect()
		#onCollide()
	end;	

	def onUpdate

	end;

	def onDetect

	end;

	def onCollide

	end;	
end;

class EmptyObject<MapObject	
	def initialize(layer, data)
		super(layer,data)
	end;	

	def draw
		if SHOW_EMPTY_OBJECTS
			Gosu.draw_line(@xx,@y,Gosu::Color::RED,@xx+@width,@y,Gosu::Color::RED,20)
			Gosu.draw_line(@xx+@width,@y,Gosu::Color::RED,@xx+@width,@y+@height,Gosu::Color::RED,20)
			Gosu.draw_line(@xx+@width,@y+@height,Gosu::Color::RED,@xx,@y+height,Gosu::Color::RED,20)
			Gosu.draw_line(@xx,@y+height,Gosu::Color::RED,@xx,@y,Gosu::Color::RED,20)
			LARGE_FONT.draw_text(@name,@xx,@y,20,1,1,Gosu::Color::RED)
		end;
	end;	
end;

class TileObject<MapObject
	attr_accessor :sx, :sy
	def initialize(layer, data)
    data["y"]-=data["height"]
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
		xx1=@flip_horizontal ? @xx+@width : @xx
		xx2=@flip_horizontal ? @xx : @xx+@width
		#yy1=@flip_vertical ? @y : @y-@height
		#yy2=@flip_vertical ? @y-@height : @y
		yy1=@flip_vertical ? @yy+@height : @yy
		yy2=@flip_vertical ? @yy : @yy+@height
   
    if @visible
      layer.master.getTileByGid(@gid).draw_as_quad(xx1,yy1,Gosu::Color::WHITE, 
                             xx2,yy1,Gosu::Color::WHITE,
                             xx2,yy2,Gosu::Color::WHITE,
                             xx1,yy2,Gosu::Color::WHITE,
                             20);
    end;                     

		if SHOW_TILED_OBJECTS
#			Gosu.draw_line(@x,@y,Gosu::Color::RED,@x+@width,@y,Gosu::Color::RED,20)
#			Gosu.draw_line(@x+@width,@y,Gosu::Color::RED,@x+@width,@y-@height,Gosu::Color::RED,20)
#			Gosu.draw_line(@x+@width,@y-@height,Gosu::Color::RED,@x,@y-height,Gosu::Color::RED,20)
#			Gosu.draw_line(@x,@y-height,Gosu::Color::RED,@x,@y,Gosu::Color::RED,20)
			Gosu.draw_line(@xx,@y,Gosu::Color::RED,@xx+@width,@y,Gosu::Color::RED,20)
			Gosu.draw_line(@xx+@width,@y,Gosu::Color::RED,@xx+@width,@y+@height,Gosu::Color::RED,20)
			Gosu.draw_line(@xx+@width,@y+@height,Gosu::Color::RED,@xx,@y+height,Gosu::Color::RED,20)
			Gosu.draw_line(@xx,@y+height,Gosu::Color::RED,@xx,@y,Gosu::Color::RED,20)
			#LARGE_FONT.draw_text(@name,@xx,@y-@height,20,1,1,Gosu::Color::RED)
      LARGE_FONT.draw_text(@name,@xx,@y,20,1,1,Gosu::Color::RED)
		end;
	end;	

	def updateTile(new_gid)
		@gid=new_gid;
	end;	
  
  def visible?
    return @visible    
  end
end;
end;