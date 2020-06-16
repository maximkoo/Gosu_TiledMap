# log levels
module Gosu_TiledMap
LOG_LEVEL=:all
LOG_LEVELS={:all=>0, :debug=>1, :severe=>2, :force=>3, :none=>4}

V_230=2**30
V_231=2**31

DATA_X={"id"=>"1000","name"=>"Layer_X","type"=>"objectgroup","visible"=>"true","x"=>"0","y"=>"0","opacity"=>"1","objects"=>[]}

class Service
	def Service.set_data_methods(obj,data)
		return if data.empty?
		data.each do |k,v|
			#puts "#{k.to_sym} #{v}"
			obj.class.class_eval do
				define_method("#{k.to_s}") do
					instance_variable_get("@#{k.to_s}");
				end;

				define_method("#{k.to_s}=") do |x|
					instance_variable_set("@#{k.to_s}", x)	
				end;
			end;
			obj.send("#{k.to_sym}=",v)
		end;
	end;

	def Service.log(str, lvl=:all)
		if lvl>=LOG_LEVEL
			puts str;
		end;	
	end;	
end;
end;