class AbstractLayer
    attr_reader :master
    def initialize(master, data)
        @master=master;
        #@id=data["id"]
        # @data=data["data"]
        # @name=data["name"]
        # @type=data["type"]
        # @visible=data["visible"]          
        # @x,@y=data["x"],data["y"]
        # @width,@height=data["width"],data["height"]
        Service.set_data_methods(self,data)
        master.layers<<self;
    end;    
end;

class TileLayer<AbstractLayer
    def initialize(master,data)
        super(master,data)
        @data=data["data"]
        puts "Tile layer created, #{data["name"]}"
        @iter=0
    end;    

    def draw
        x,y=@x,@y;      # the layer offset      
        (0..@height-1).each do |i|
            (0..@width-1).each do |j|
                gid=@data[i*@width+j]
                if gid!=0 
                    tile=@master.getTileByGid(gid);
                    tile.draw(j*tile.width, i*tile.height,10,1,1)
                end;    
            end;    
        end;    
    end;
end;

class ObjectLayer<AbstractLayer
    attr_accessor :objects
    def initialize(master,data)
        super(master,data)
        @data=data
        #@objects=data["objects"]
        puts "Object layer created, #{@data["name"]}"
        @objects=[]
        read_objects(@data)
            #binding.pry
    end;

    def draw
        @objects.each do |obj|
            obj.draw;
        end;
    end;

    private
    def read_objects(data)
        return if data.empty?
        data["objects"].each do |objdata|
            if objdata["gid"] 
                @objects<<TileObject.new(self,objdata)
            else
                @objects<<EmptyObject.new(self,objdata)
            end;    
        end; 
    end;  
end; 