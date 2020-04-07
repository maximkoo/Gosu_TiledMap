require_relative './layer.rb'
require_relative './tileset.rb'
require_relative './objects.rb'
require_relative './animation.rb'
require 'json'
require_relative './service.rb'

OBJECTLAYER="objectgroup"
TILELAYER="tilelayer"
SHOW_EMPTY_OBJECTS=true
SHOW_TILED_OBJECTS=true
LARGE_FONT= Gosu::Font.new(height=20,options={name:"Courier New"})

class TiledMap
	attr_reader :height,:width, :layers, :tilesets 

	def initialize(path_to_map,file_name)
		begin
			json=JSON.parse(File.read(File.join(path_to_map,file_name)))
		rescue Errno::ENOENT
			abort("The file does not exist!");
		rescue JSON::ParserError
			abort("The file is not well-formed!");
		end;
		puts "Can not process infinite maps" if json["infinite"]=="true"
		@height=json["height"]
		@width=json["width"]
		@tilewidth=json["tilewidth"]
		@tileheight=json["tileheight"]

		@layers=[]
		@tilesets=[]

		json["layers"].each do |layer_data|
			if layer_data["type"]==TILELAYER
				TileLayer.new(self, layer_data);
			elsif layer_data["type"]==OBJECTLAYER
				ObjectLayer.new(self, layer_data);
			end;	
		end;	

		@layer_x=ObjectLayer.new(self, DATA_X);

		json["tilesets"].each do |tileset_data|
			Tileset.new(self, tileset_data);
		end;	

		## Tile bound objects
		@tilesets.each do |tset|
			if tset.tiles_data
				tset.tiles_data.each do |tdata| #id
				 	if tdata["objectgroup"]				 		
				 		tdata["objectgroup"]["objects"].each do |tobj|
				 			if tobj["type"]=="TileBoundObstacle"    
				 				# Отыскиваем во всех слоях тайл с указанным id+1. Если здесь 40, то ищем 41
				 				@layers.select{|l| l.class.name=="TileLayer"}.each do |layer|
				 					#layer.data.select{|v| v == tdata["id"]+1}.each do |k|
				 					layer.data.each_index do |ki|
				 						if layer.data[ki]==tdata["id"]+1
				 							puts "In the layer #{layer.name} found tile id=#{layer.data[ki]}, pos=#{ki}, x=#{ki%layer.width}, y=#{ki/layer.width}"
				 							n=EmptyObject.new(@layer_x,tobj)
				 							n.x=tset.tilewidth*(ki%layer.width)
				 							n.y=tset.tilewidth*(ki/layer.width)
				 							n.width, n.height=tset.tilewidth, tset.tileheight
				 							n.name="tb_#{tset.name}_#{ki}"
				 						end;	
				 					end;	
				 				end;	
				 			end;	
				 		end;	
				 	end;					
				end;	
			end;	
		end;	
		##
		@animations=[]
		@tilesets.each do |t|
			@animations+=t.animations if t.animations
		end;	
		puts "Tiled Map reporting: animations count is #{@animations.size}"		
		@animations
	end;	

	def all_objects
		#return all objects from all layers
		objs=[]
		@layers.each do |layer|
			objs+=layer.objects if layer.class.name=="ObjectLayer"
		end;
		objs
	end;	

	def all_animations
		@animations
	end;	

	def getTilesetByGid(n)
		#nn=n-2**31 if n>1000000
		nn=nil;
		@tilesets.select{|t| (nn||=n).between?(t.firstgid, t.lastgid)}.first
	end;	

	def getTileByGid(gid)
		tileset=getTilesetByGid(gid)
		#puts "GID=#{gid}"
		
		# if @animations.any?{|ani| ani.gid==gid}
		# 	a=@animations.select{|ani| ani.gid==gid}.first
		# 	local_id=a.current_gid+a.master.firstgid
		# 	puts "got it, local_id=#{local_id}"
		# else 
		# 	local_id=gid-tileset.firstgid;	
		# end;	
		local_id=nil;
		@animations.select{|ani| ani.big_gid==gid}.each do |a|
			#puts "a.big_gid=#{a.big_gid}"
			#puts "gid=#{gid}"
			local_id=a.current_gid#+a.master.firstgid
			#puts "a.current_gid=#{a.current_gid}"
			#puts "a.master.firstgid=#{a.master.firstgid}"
			#puts "local_id(1)=#{local_id}"
			break
		end;
		local_id=gid-tileset.firstgid if local_id.nil?;	
		#puts "local_id(2)=#{local_id}"
		#local_id-=2**31 if local_id>1000000
		tileset.getTileByLocalId(local_id)
	end;

	def draw
		@layers.each do |layer|
			layer.draw;
		end;	
	end;
end;