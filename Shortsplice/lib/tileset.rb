module Gosu_TiledMap
class Tileset
	attr_reader :firstgid, :lastgid, :name, :tiles, :tilewidth, :tileheight, :tiles_data , :animations
	def initialize(master, data)
		@firstgid=data["firstgid"]
		@tilecount=data["tilecount"]
		@lastgid=@firstgid+@tilecount-1
		@name=data["name"]
		@columns=data["columns"]
		
		@tileheight=data["tileheight"]
		@tilewidth=data["tilewidth"]

		@tiles_data=data["tiles"]

		path=File.join(File.dirname($0),'assets','images',data["image"]);
    puts path;
		@tiles=Gosu::Image.load_tiles(path, data["tilewidth"], data["tileheight"],{tileable:true});

		read_animations(data)
			#binding.pry
		master.tilesets<<self;
	end;

	def getTileByLocalId(id)		
		@tiles[id]
	end;	

	def getTileByTilesetAndId

	end;

	private def read_animations(data)
		@animations=[]
		#@tileBounds=[]
		if data["tiles"]
			data["tiles"].each do |a|				
				@animations<<Animation.new(self, a) if a["animation"] # data["tiles"] could be TileBoundObstacle
			end;
		end;	
	end;	
end;
end;